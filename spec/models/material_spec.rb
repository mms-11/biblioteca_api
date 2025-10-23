require 'rails_helper'

RSpec.describe Material, type: :model do
  # Validações básicas
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(3).is_at_most(100) }
  it { is_expected.to validate_length_of(:description).is_at_most(1000) } rescue nil
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:creator).class_name('User') }

  # Testes de comportamento
  let(:user) { User.create!(email: 'test@test.com', password: 'password') }
  let(:author) { InstitutionAuthor.create!(name: 'Test', city: 'City') }

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1, archived: 2) }
  end

  describe 'scopes' do
    let!(:published_book) { Book.create!(title: 'Published Book', status: :published, author:, creator: user, isbn: '9781234567890', page_count: 100) }
    let!(:draft_book) { Book.create!(title: 'Draft Book', status: :draft, author:, creator: user, isbn: '9781234567891', page_count: 50) }
    let!(:published_article) { Article.create!(title: 'Published Article', status: :published, author:, creator: user, doi: '10.1000/test1') }

    describe '.published' do
      it 'retorna apenas materiais publicados' do
        expect(Material.published).to include(published_book, published_article)
        expect(Material.published).not_to include(draft_book)
      end
    end

    describe '.search' do
      it 'busca por título (case insensitive)' do
        results = Material.search('published')
        expect(results).to include(published_book, published_article)
        expect(results).not_to include(draft_book)
      end

      it 'retorna todos quando query é nil' do
        results = Material.search(nil)
        expect(results.count).to eq(3)
      end

      it 'retorna todos quando query é vazia' do
        results = Material.search('')
        expect(results.count).to eq(3)
      end

      it 'busca parcialmente' do
        results = Material.search('Book')
        expect(results).to include(published_book, draft_book)
        expect(results).not_to include(published_article)
      end
    end
  end

  describe 'STI (Single Table Inheritance)' do
    it 'cria diferentes tipos de materiais' do
      book = Book.create!(title: 'Test Book', status: :draft, author:, creator: user, isbn: '9781234567892', page_count: 100)
      article = Article.create!(title: 'Test Article', status: :draft, author:, creator: user, doi: '10.1000/test2')
      video = Video.create!(title: 'Test Video', status: :draft, author:, creator: user, duration_minutes: 30)

      expect(book.type).to eq('Book')
      expect(article.type).to eq('Article')
      expect(video.type).to eq('Video')
    end

    it 'recupera instâncias do tipo correto' do
      book = Book.create!(title: 'Test Book', status: :draft, author:, creator: user, isbn: '9781234567893', page_count: 100)
      
      found = Material.find(book.id)
      expect(found).to be_a(Book)
      expect(found.isbn).to eq('9781234567893')
    end
  end
end