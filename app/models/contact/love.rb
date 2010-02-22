class Contact::Love < Contact
  
  key :message, String
  
  validates_presence_of :message, :message => "can't be blank"
  
end
