class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource, store: false)

    response.headers['Authorization'] = "Bearer #{request.env['warden-jwt_auth.token']}"
    render json: { message: 'signed_in', user: { id: resource.id, email: resource.email }, token: token }, status: :ok
  end

  def destroy
    sign_out(resource_name)
    head :no_content
  end
end
