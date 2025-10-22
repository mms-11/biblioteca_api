class InstitutionAuthor < Author
  validates :name, length: { in: 3..120 }
  validates :city, presence: true, length: { in: 2..80 }
end
