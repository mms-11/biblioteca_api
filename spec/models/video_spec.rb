require 'rails_helper'

RSpec.describe Video, type: :model do
  it { is_expected.to validate_presence_of(:duration_minutes) }
  it { is_expected.to validate_numericality_of(:duration_minutes).only_integer.is_greater_than(0) }
end