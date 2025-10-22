class PersonAuthor < Author
  validates :name, length: { in: 3..80 }
  validates :birthdate, presence: true
  validate  :birthdate_cannot_be_in_future

  private

  def birthdate_cannot_be_in_future
    return if birthdate.blank?
    errors.add(:birthdate, 'não pode ser futura') if birthdate > Date.today
  end
end
