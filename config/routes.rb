Rails.application.routes.draw do
  # =========================
  # 📘 Documentação Swagger
  # =========================
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine  => '/docs'

  # =========================
  # Página inicial / Healthcheck
  # =========================
  # Root simples
  root to: proc { [200, { 'Content-Type' => 'text/plain' }, ['Biblioteca API is running!']] }

  # Health check para Render (usa rota padrão do Rails)
  get "up" => "rails/health#show", as: :rails_health_check

  # =========================
  # Autenticação (Devise JSON)
  # =========================
  devise_for :users,
    defaults: { format: :json },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  # =========================
  #  GraphQL endpoint
  # =========================
  post "/graphql", to: "graphql#execute"

  # =========================
  # API REST v1
  # =========================
  namespace :api do
    namespace :v1 do
      resources :authors      # /api/v1/authors
      resources :materials    # /api/v1/materials
      get "ping", to: "ping#index"
    end
  end
end
