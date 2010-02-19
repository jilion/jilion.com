class Contact::Job < Contact
  
  key :message, String, :required => true
  key :file, String, :required => true
  
end
