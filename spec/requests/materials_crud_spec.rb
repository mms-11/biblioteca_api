# frozen_string_literal: true
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Materials CRUD', type: :request do
  let(:user) { User.create!(email: 'crud@demo.com', password: 'secret123') }
  let(:authz) do
    token, = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    "Bearer #{token}"
  end
  let(:author) { InstitutionAuthor.create!(name: 'CIN', city: 'Recife') }

  before do
    # evita rede caso algum caminho tente OpenLibrary
    stub_request(:get, "https://openlibrary.org/api/books")
      .with(query: hash_including(format: "json", jscmd: "data"))
      .to_return(status: 200, body: {}.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'create -> show -> update -> destroy (200/201/200/204)' do
    # create
    post '/api/v1/materials',
         params: { type: 'Book', title: 'CRUD', status: 'draft', author_id: author.id,
                   isbn: '9781234567999', page_count: 10 }.to_json,
         headers: { 'Content-Type' => 'application/json', 'Authorization' => authz }
    expect(response).to have_http_status(:created)
    created = JSON.parse(response.body)
    id = created['id']

    # show (público se published; como está draft, precisa do token)
    get "/api/v1/materials/#{id}", headers: { 'Accept' => 'application/json', 'Authorization' => authz }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include('title' => 'CRUD')

    # update
    patch "/api/v1/materials/#{id}",
          params: { title: 'CRUD 2' }.to_json,
          headers: { 'Content-Type' => 'application/json', 'Authorization' => authz }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include('title' => 'CRUD 2')

    # destroy
    delete "/api/v1/materials/#{id}", headers: { 'Authorization' => authz }
    expect(response).to have_http_status(:no_content)
  end
end
