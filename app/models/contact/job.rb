class Contact::Job < Contact

  attr_accessible :job_id

  field :job_id, type: String

  validates :file, presence: true

  belongs_to :job

end
