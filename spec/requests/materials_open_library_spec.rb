require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Materials (OpenLibrary enrichment)", type: :request do
  let!(:user)   { User.create!(email: 'jwt@demo.com', password: 'secret123') }
  let!(:author) { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }

  # helper para token JWT (Devise+JWT despacha Authorization no header)
  def auth_token_for(user)
    post '/users/sign_in.json',
      params: { user: { email: user.email, password: 'secret123' } }.to_json,
      headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    # DEBUG: Vamos ver o que está sendo retornado
    puts "Status: #{response.status}"
    puts "Body: #{response.body}"
    puts "Headers: #{response.headers.inspect}"

    # Aceita 200 (ok) ou 201 (created), depende da tua implementação
    expect(response).to have_http_status(:ok).or have_http_status(:created)

    token = response.headers['Authorization']
    raise "JWT não retornado no header Authorization. Body: #{response.body}" if token.blank?
    token
  end

  it 'preenche title e page_count quando ausentes para Book com ISBN' do
    token = auth_token_for(user)

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
      }.to_json

    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body['title']).to eq('The C Programming Language')
    expect(body['page_count']).to eq(274)
    expect(body['isbn']).to eq(isbn)
  end
end