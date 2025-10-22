class Api::V1::MaterialsController < ApplicationController
  before_action :set_material, only: %i[show update destroy]

  # leitura pública (publicados) e privada (seus próprios via scope)
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    materials = policy_scope(Material)
                  .includes(:author)
                  .search(params[:q])
                  .order(created_at: :desc)
                  .page(params[:page]).per(params[:per] || 20)

    render json: materials.map { |m| material_json(m) }
  end

  def show
    authorize @material
    render json: material_json(@material)
  end

  def create
    authorize Material
    klass = (params[:type] || 'Material').safe_constantize
    return render json: { error: 'type inválido' }, status: :unprocessable_entity unless klass && klass <= Material

    material = klass.new(base_params.merge(creator: current_user).merge(specific_params(klass)))

    # OpenLibrary: se for Book e faltarem campos, completar
    enrich_from_openlibrary(material) if material.is_a?(Book)

    authorize material
    if material.save
      render json: material_json(material), status: :created
    else
      render json: { errors: material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @material
    klass = @material.class
    if @material.update(base_params.merge(specific_params(klass)))
      render json: material_json(@material)
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @material
    @material.destroy
    head :no_content
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def base_params
    params.permit(:type, :title, :description, :status, :author_id)
  end

  def specific_params(klass)
    case klass.name
    when 'Book'    then params.permit(:isbn, :page_count)
    when 'Article' then params.permit(:doi)
    when 'Video'   then params.permit(:duration_minutes)
    else {}
    end
  end

  def enrich_from_openlibrary(book)
    return if book.isbn.blank?
    data = OpenLibraryClient.fetch_by_isbn(book.isbn)
    book.title      = data[:title] if book.title.blank? && data[:title].present?
    book.page_count = data[:number_of_pages] if book.page_count.blank? && data[:number_of_pages].present?
  rescue => e
    Rails.logger.warn "OpenLibrary enrichment failed: #{e.message}"
  end

  def material_json(m)
    m.as_json(only: %i[id type title description status],
              include: { author: { only: %i[id type name] } })
     .merge(specific_json(m))
  end

  def specific_json(m)
    case m
    when Book    then { isbn: m.isbn, page_count: m.page_count }
    when Article then { doi: m.doi }
    when Video   then { duration_minutes: m.duration_minutes }
    else {}
    end
  end
end
