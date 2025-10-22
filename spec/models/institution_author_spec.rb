require 'rails_helper'

RSpec.describe InstitutionAuthor, type: :model do
  it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(120) }
  it { is_expected.to validate_presence_of(:city) }
end