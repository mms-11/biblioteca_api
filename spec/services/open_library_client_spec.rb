require 'rails_helper'
require 'webmock/rspec'

RSpec.describe OpenLibraryClient do
  it 'retorna título e número de páginas a partir do ISBN' do
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

    data = described_class.fetch_by_isbn(isbn)
    expect(data[:title]).to eq("The C Programming Language")
    expect(data[:number_of_pages]).to eq(274)
  end

it 'retorna {} em erro HTTP' do
  isbn = '9780000000000'

  stub_request(:get, "https://openlibrary.org/api/books")
    .with(query: hash_including(bibkeys: "ISBN:#{isbn}", format: "json", jscmd: "data"))
    .to_return(status: 500, body: "", headers: {})

  expect(OpenLibraryClient.fetch_by_isbn(isbn)).to eq({})
end

end
