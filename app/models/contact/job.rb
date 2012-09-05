class Contact::Job < Contact

  field :message, :type => String
  field :job_id,  :type => String

  validates_presence_of :message
  validates_presence_of :file

  belongs_to :job

end
