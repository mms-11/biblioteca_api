require 'rails_helper'

RSpec.describe Material, type: :model do
  it { is_expected.to validate_presence_of(:type) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(3).is_at_most(100) }
  it { is_expected.to validate_length_of(:description).is_at_most(100) } rescue nil
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:creator).class_name('User') }
end