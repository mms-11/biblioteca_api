class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /users/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource, store: false)

    # 1) tente usar o token já emitido pelo devise-jwt
    token = request.env['warden-jwt_auth.token']
    # 2) fallback: gera manualmente se por algum motivo não veio no env
    token ||= Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    response.set_header('Authorization', "Bearer #{token}")
    render json: {
      message: 'signed_in',
      user: { id: resource.id, email: resource.email },
      token: token
    }, status: :ok
  end

  # DELETE /users/sign_out
  def destroy
    sign_out(resource_name)
    respond_to_on_destroy
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end
