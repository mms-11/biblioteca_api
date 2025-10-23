
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply a hash where the value is a boolean determining whether
  # or not authentication should be aborted when the value is not present.
  # config.authentication_keys = [:email]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to the
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]


  config.skip_session_storage = [:http_auth]


  config.reconfirmable = true

  # Defines which key will be used when confirming an account
  # config.confirmation_keys = [:email]

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  
  config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/


  config.reset_password_within = 6.hours

 
  config.sign_out_via = :delete

  
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
  config.navigational_formats = []

  # ==> Configuration for :registerable

  # When set to false, does not sign a user in automatically after their password is
  # changed. Defaults to true, so a user is signed in automatically after changing a password.
  # config.sign_in_after_change_password = true
  # ==> Configuration for JWT
  config.jwt do |jwt|
    #jwt.secret = ENV['DEVISE_JWT_SECRET_KEY'] || Rails.application.credentials.devise_jwt_secret_key || Rails.application.secret_key_base
    
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}]
    ]
    
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]
    
    jwt.expiration_time = 1.day.to_i
  end




  # Resposta apenas JSON (evita 406/500 por HTML)
config.navigational_formats = []

# Se Vc NÃO usa credentials em prod, não force credentials aqui:
# config.secret_key = Rails.application.credentials.secret_key_base
# Use a secret_key_base do Rails ou uma env separada:
config.secret_key = ENV['DEVISE_SECRET_KEY'] || Rails.application.secret_key_base

# JWT
config.jwt do |jwt|
  jwt.secret = ENV['JWT_SECRET']                # já existe no Render
  jwt.dispatch_requests = [
    ['POST', %r{^/users/sign_in$}],
    ['POST', %r{^/users$}]                      # retorno de token no cadastro (opcional)
  ]
  jwt.revocation_requests = [
    ['DELETE', %r{^/users/sign_out$}]
  ]
  jwt.expiration_time = 1.day.to_i
end
end


