class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      sign_in(resource_name, resource, store: false)
      render json: { message: 'signed_up', user: { id: resource.id, email: resource.email } }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
