require 'rails_helper'
require 'webmock/rspec'
require 'warden/jwt_auth'   # para gerar o token manualmente

RSpec.describe "Materials (OpenLibrary enrichment)", type: :request do
  let!(:user)   { User.create!(email: 'jwt@demo.com', password: 'secret123') }
  let!(:author) { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }

  # Gera um Bearer JWT válido para o usuário (sem chamar /users/sign_in)
  def bearer_for(user)
    encoder = Warden::JWTAuth::UserEncoder.new
    token, _payload = encoder.call(user, :user, nil) # :user é o Devise scope
    "Bearer #{token}"
  end

  it 'preenche title e page_count quando ausentes para Book com ISBN' do
    token = bearer_for(user)

    isbn = '9780131103627'
    payload = {
      "ISBN:#{isbn}" => {
        "title" => "The C Programming Language",
        "number_of_pages" => 274
      }
    }

    stub_request(:get, "https://openlibrary.org/api/books")
      .with(query: hash_including(bibkeys: "ISBN:#{isbn}", format: "json", jscmd: "data"))
      .to_return(status: 200, body: payload.to_json, headers: { 'Content-Type' => 'application/json' })

    post '/api/v1/materials',
      headers: {
        'Authorization' => token,
        'CONTENT_TYPE'  => 'application/json',
        'ACCEPT'        => 'application/json'
      },
      params: {
        type: 'Book',
        status: 'draft',
        author_id: author.id,
        isbn: isbn
        # sem title e sem page_count de propósito
      }.to_json

    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body['title']).to eq('The C Programming Language')
    expect(body['page_count']).to eq(274)
    expect(body['isbn']).to eq(isbn)
  end
end