require 'rails_helper'

RSpec.describe PersonAuthor, type: :model do
  it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(80) }
  it { is_expected.to validate_presence_of(:birthdate) }

  it 'não aceita data futura' do
    pa = PersonAuthor.new(name: 'Ana', birthdate: Date.today + 1)
    expect(pa.valid?).to be false
    expect(pa.errors[:birthdate]).to be_present
  end
end