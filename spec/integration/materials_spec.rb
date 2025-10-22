require 'swagger_helper'
require 'webmock/rspec'

RSpec.describe 'api/v1/materials', type: :request do
  before do
    # stub genérico para qualquer chamada à OpenLibrary
    stub_request(:get, "https://openlibrary.org/api/books")
      .with(query: hash_including(format: "json", jscmd: "data"))
      .to_return(status: 200, body: {}.to_json, headers: { 'Content-Type' => 'application/json' })
  end
  
  let(:user)   { User.create!(email: 'doc@demo.com', password: 'secret123') }
  let(:author) { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }
  let(:Authorization) do
    token, _ = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    "Bearer #{token}"
  end

  path '/api/v1/materials' do
    get('Lista materiais (públicos e seus)') do
      tags 'Materials'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, required: false
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per, in: :query, type: :integer, required: false

      response(200, 'ok') do
        # ADD THESE LINES to provide default values for the parameters:
        let(:q) { nil }
        let(:page) { nil }
        let(:per) { nil }
        
        run_test!
      end
    end

    post('Cria material') do
      tags 'Materials'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :body, in: :body, schema: {
        type: :object,
        required: %i[type title status author_id],
        properties: {
          type: { type: :string, example: 'Book' },
          title: { type: :string, example: 'Estruturas de Dados' },
          description: { type: :string, nullable: true },
          status: { type: :string, example: 'draft' },
          author_id: { type: :integer, example: 1 },
          isbn: { type: :string, example: '9781234567890' },
          page_count: { type: :integer, example: 120 }
        }
      }

      response(201, 'created') do
        let(:body) { { type: 'Book', title: 'Doc Book', status: 'draft', author_id: author.id, isbn: '9781234567890', page_count: 100 } }
        let(:Authorization) { super() }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:body) { { type: 'Book', title: 'No Auth', status: 'draft', author_id: author.id, isbn: '9781234567899', page_count: 100 } }
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/materials/{id}' do
    parameter name: :id, in: :path, type: :string, description: 'ID do material'

    get('Mostra material') do
      tags 'Materials'
      produces 'application/json'
      response(200, 'ok') do
        let(:id) { Book.create!(title: 'Pub', status: :published, author:, creator: user, isbn: '9781234567800', page_count: 10).id }
        run_test!
      end
    end

    patch('Atualiza material') do
      tags 'Materials'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string }
        }
      }
      response(200, 'ok') do
        let(:Authorization) { super() }
        let(:id) { Book.create!(title: 'Meu', status: :draft, author:, creator: user, isbn: '9781234567801', page_count: 11).id }
        let(:body) { { title: 'Atualizado' } }
        run_test!
      end
    end

    delete('Remove material') do
      tags 'Materials'
      security [ bearerAuth: [] ]
      response(204, 'no content') do
        let(:Authorization) { super() }
        let(:id) { Book.create!(title: 'Meu 2', status: :draft, author:, creator: user, isbn: '9781234567802', page_count: 12).id }
        run_test!
      end
    end
  end
end