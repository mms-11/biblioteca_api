require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user)   { User.create!(email: 'u2@u.com', password: 'secret123') }
  let(:author) { InstitutionAuthor.create!(name: 'UFPE', city: 'Recife') }

  it 'valida presença e formato do DOI' do
    a = Article.new(title: 'X', status: :draft, author:, creator: user, doi: 'abc')
    expect(a.valid?).to be false
    expect(a.errors[:doi]).to be_present
  end

  it 'não permite DOI duplicado' do
     Article.create!(title: 'AAA', status: :draft, author:, creator: user, doi: '10.1000/xyz123')
     dup = Article.new(title: 'BBB', status: :draft, author:, creator: user, doi: '10.1000/xyz123')
     expect(dup.valid?).to be false
     expect(dup.errors[:doi]).to include(/já está em uso|has already been taken/i)
    
    
  end
end