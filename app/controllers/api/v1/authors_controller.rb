class Api::V1::AuthorsController < ApplicationController
  # controller de autores para leitura
  # criar/editar/excluir exige login
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    authors = Author.order(:name).page(params[:page]).per(params[:per] || 20)
    render json: authors.as_json(only: %i[id type name birthdate city])
  end

  def show
    author = Author.find(params[:id])
    render json: author.as_json(only: %i[id type name birthdate city])
  end

  def create
    klass = params[:type].presence&.safe_constantize
    return render json: { error: 'type inválido' }, status: :unprocessable_entity unless [PersonAuthor, InstitutionAuthor].include?(klass)

    author = klass.new(author_params)
    if author.save
      render json: author.as_json(only: %i[id type name birthdate city]), status: :created
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    author = Author.find(params[:id])
    if author.update(author_params)
      render json: author.as_json(only: %i[id type name birthdate city])
    else
      render json: { errors: author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    author = Author.find(params[:id])
    author.destroy
    head :no_content
  end

  private

  def author_params
    params.permit(:type, :name, :birthdate, :city)
  end
end
