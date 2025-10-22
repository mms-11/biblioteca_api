class ApplicationController < ActionController::API #classe base que todos os controlllers vao herdar!!
  include Pundit::Authorization
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do #verifica autorizaçao do usuario e retorna http 403 se for proibibido o aceesso
    render json: { error: 'forbidden' }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do #captura execeçoes
    render json: { error: 'not_found' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
