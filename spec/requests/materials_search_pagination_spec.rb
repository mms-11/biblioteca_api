require 'rails_helper'

RSpec.describe "Materials search & pagination", type: :request do
  let!(:user)   { User.create!(email: 'u@u.com', password: 'secret123') }
  let!(:author) { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }

  before do
    3.times do |i|
      Book.create!(title: "Ruby #{i}", status: :published, author:, creator: user,
                   isbn: "97812345678#{i}0", page_count: 10 + i)
    end
  end

  it 'busca por título e pagina resultados' do
    get '/api/v1/materials', params: { q: 'Ruby', page: 1, per: 2 }
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body.size).to eq(2)

    get '/api/v1/materials', params: { q: 'Ruby', page: 2, per: 2 }
    body2 = JSON.parse(response.body)
    expect(body2.size).to eq(1)
  end
end