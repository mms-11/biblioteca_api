Rails.application.routes.draw do
  # Swagger (documentação)
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine  => '/docs'

  # GraphQL
  post "/graphql", to: "graphql#execute"

  # Autenticação Devise (JSON)
  devise_for :users, 
    defaults: { format: :json },
    controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Namespace da API 
  namespace :api do
    namespace :v1 do
      resources :authors          # rotas para autores GET/POST /api/v1/authors, /api/v1/authors/:id
      resources :materials        # rotas para materiais GET/POST /api/v1/materials, GET/PATCH/DELETE /api/v1/materials/:id
      get "ping", to: "ping#index"
    end
  end

  # root 
  # root "api/v1/ping#index"
end
