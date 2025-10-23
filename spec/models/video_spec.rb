require 'rails_helper'

RSpec.describe Video, type: :model do
  # Validações
  it { is_expected.to validate_presence_of(:duration_minutes) }
  it { is_expected.to validate_numericality_of(:duration_minutes).only_integer.is_greater_than(0) }

  # Testes de comportamento
  let(:user) { User.create!(email: 'video@test.com', password: 'password') }
  let(:author) { InstitutionAuthor.create!(name: 'Test', city: 'City') }

  describe 'criação' do
    it 'cria video válido' do
      video = Video.create!(
        title: 'Tutorial Rails',
        status: :published,
        author:,
        creator: user,
        duration_minutes: 45
      )

      expect(video).to be_persisted
      expect(video.duration_minutes).to eq(45)
      expect(video).to be_a(Material)
    end

    it 'não cria video sem duration_minutes' do
      video = Video.new(title: 'Test', status: :draft, author:, creator: user)
      expect(video.valid?).to be false
      expect(video.errors[:duration_minutes]).to be_present
    end

    it 'não cria video com duration_minutes zero' do
      video = Video.new(title: 'Test', status: :draft, author:, creator: user, duration_minutes: 0)
      expect(video.valid?).to be false
    end

    it 'não cria video com duration_minutes negativo' do
      video = Video.new(title: 'Test', status: :draft, author:, creator: user, duration_minutes: -10)
      expect(video.valid?).to be false
    end
  end

  describe 'herança' do
    it 'é uma subclasse de Material' do
      expect(Video.superclass).to eq(Material)
    end
  end
end