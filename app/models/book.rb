class Book < Material
  validates :isbn, presence: true, uniqueness: true, format: { with: /\A\d{13}\z/ }
  validates :page_count, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
