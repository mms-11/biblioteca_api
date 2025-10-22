class Author < ApplicationRecord
  has_many :materials, dependent: :restrict_with_exception

  validates :type, presence: true
  validates :name, presence: true
end
