class Material < ApplicationRecord
  belongs_to :author
  belongs_to :creator, class_name: 'User'

  # Status (enum) — rascunho, publicado, arquivado
  enum :status,{ draft: 0, published: 1, archived: 2 }

  # Validações comuns a todos os materiais
  validates :type, presence: true
  validates :title, presence: true, length: { in: 3..100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validates :status, presence: true
  validates :author, presence: true
  validates :creator, presence: true

  # Busca por título, descrição e nome do autor
  scope :search, ->(q) {
    return all if q.blank?
    joins(:author).where(
      "materials.title ILIKE :q OR materials.description ILIKE :q OR authors.name ILIKE :q",
      q: "%#{q}%"
    )
  }
end