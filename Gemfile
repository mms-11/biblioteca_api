source "https://rubygems.org"

gem "rails", "~> 8.0.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]

# Rails 8 defaults
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# --- API / Auth / Segurança ---
gem "devise"
gem "devise-jwt"
gem "pundit"
gem "rack-cors"            # CORS para o mini-frontend (ou Swagger) acessar a API
gem "dotenv-rails", groups: %i[development test]  # para ler JWT_SECRET do .env

# --- Funcionalidades do Desafio ---
gem "kaminari"             # paginação
gem "faraday"              # OpenLibrary client
gem "graphql"              # diferencial GraphQL
gem "rswag-api"            # Swagger
gem "rswag-ui"
gem "rswag-specs"

group :development, :test do
  gem "rspec-rails"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
