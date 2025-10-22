require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:user)   { User.create!(email: 'u@u.com', password: 'secret123') }
  let(:author) { InstitutionAuthor.create!(name: 'CIN/UFPE', city: 'Recife') }

  it 'valida presença e formato do ISBN' do
    b = Book.new(title: 'X', status: :draft, author:, creator: user, isbn: '123', page_count: 10)
    expect(b.valid?).to be false
    expect(b.errors[:isbn]).to be_present
  end

  it 'não permite ISBN duplicado' do
    Book.create!(title: 'AAA', status: :draft, author:, creator: user, isbn: '9781234567890', page_count: 10)
    dup = Book.new(title: 'BBB', status: :draft, author:, creator: user, isbn: '9781234567890', page_count: 5)
    expect(dup.valid?).to be false
     expect(dup.errors[:isbn]).to include(/já está em uso|has already been taken/i)
  end

  it 'exige page_count > 0' do
    b = Book.new(title: 'X', status: :draft, author:, creator: user, isbn: '9781234567891', page_count: 0)
    expect(b.valid?).to be false
    expect(b.errors[:page_count]).to be_present
  end
end