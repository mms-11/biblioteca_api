Rails.application.routes.draw do
  # Swagger (documentação)
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine  => '/docs'

  # GraphQL
  post "/graphql", to: "graphql#execute"

  # Autenticação Devise (JSON)
  devise_for :users, defaults: { format: :json }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Namespace da API 
  namespace :api do
    namespace :v1 do
      get "ping", to: "ping#index"
    end
  end

  # root 
  # root "api/v1/ping#index"
end
