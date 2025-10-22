require 'rails_helper'

RSpec.describe MaterialPolicy do
  let(:creator) { User.create!(email: 'a@a.com', password: 'secret123') }
  let(:other)   { User.create!(email: 'b@b.com', password: 'secret123') }
  let(:author)  { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }
  let!(:book)    { Book.create!(title: 'XXX', status: :draft, author:, creator:, isbn: '9781234567890', page_count: 10) }

  it 'permite update ao criador' do
    expect(described_class.new(creator, book).update?).to be true
  end

  it 'nega update a terceiros' do
    expect(described_class.new(other, book).update?).to be false
  end

  it 'scope: logado vê publicados e os próprios' do
    Book.create!(title: 'Pub', status: :published, author:, creator: other, isbn: '9781234567891', page_count: 10)
    scope = MaterialPolicy::Scope.new(creator, Material.all).resolve
    expect(scope.map(&:title)).to include('XXX', 'Pub')
  end
end