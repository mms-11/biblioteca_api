require 'rails_helper'

RSpec.describe Article, type: :model do
  it { is_expected.to validate_presence_of(:doi) }
  it { is_expected.to validate_uniqueness_of(:doi) }
  it { is_expected.to allow_value('10.1000/xyz123').for(:doi) }
end