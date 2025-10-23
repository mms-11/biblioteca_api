class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /users
  def create
    build_resource(sign_up_params)
    resource.save

    if resource.persisted?
      # já loga ao cadastrar
      sign_in(resource_name, resource, store: false)

      token = request.env['warden-jwt_auth.token']
      token ||= Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

      response.set_header('Authorization', "Bearer #{token}")
      render json: {
        message: 'signed_up',
        user: { id: resource.id, email: resource.email },
        token: token
      }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
