# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Authors API', type: :request do
  let(:user) { User.create!(email: 'cov@demo.com', password: 'secret123') }
  let(:authz) do
    token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    "Bearer #{token}"
  end

  describe 'GET /api/v1/authors' do
    it 'retorna 200 com lista' do
      InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife')
      get '/api/v1/authors', headers: { 'Accept' => 'application/json' }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body) rescue []
      expect(body).to be_a(Array)
      expect(body.first).to include('name' => 'CIN/UFPE')
    end
  end

  describe 'POST /api/v1/authors' do
    it 'cria InstitutionAuthor com JWT' do
      post '/api/v1/authors',
           params: { type: 'InstitutionAuthor', name: 'UFPE', city: 'Recife' }.to_json,
           headers: { 'Content-Type' => 'application/json', 'Authorization' => authz }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body).to include('name' => 'UFPE', 'type' => 'InstitutionAuthor')
    end
  end
end
