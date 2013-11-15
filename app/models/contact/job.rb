class Contact::Job < Contact

  field :job_id, type: String

  validates :file, presence: true

  belongs_to :job

end
