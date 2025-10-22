class Article < Material
  validates :doi, presence: true, uniqueness: true,
                  format: { with: %r{\A10\.\d{4,9}/[-._;()/:A-Z0-9]+\z}i }
end
