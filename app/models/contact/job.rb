class Contact::Job < Contact
  
  key :message, String, :required => true
  key :job_id, String, :required => true
  
  validates_presence_of :file, :message => "can't be blank"
  
end