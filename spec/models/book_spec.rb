require 'rails_helper'

RSpec.describe Book, type: :model do
  it { is_expected.to validate_presence_of(:isbn) }
  it { is_expected.to validate_uniqueness_of(:isbn) }
  it { is_expected.to allow_value('9781234567890').for(:isbn) }
  it { is_expected.to validate_numericality_of(:page_count).only_integer.is_greater_than(0) }
end
