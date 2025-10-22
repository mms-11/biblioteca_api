require 'swagger_helper'

RSpec.describe 'api/v1/materials', type: :request do
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
      parameter name: :q, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per, in: :query, type: :integer

      response(200, 'ok') do
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
