class Contact::Job < Contact
  
  key :message, String
  
  validates_presence_of :message, :message => "can't be blank"
  validates_presence_of :file, :message => "can't be blank"
  
end
