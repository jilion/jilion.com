class Contact::Job < Contact

  validates :file, presence: true

  belongs_to :job

end
