class Contact::Deal < Contact
  
  key :name, String
  key :organization, String
  key :url, String
  key :activity, String
  key :project_description, String
  key :budget, String, :required => true
  key :goal, String
  key :metrics, String
  key :challenge, String
  key :deadline, String
  key :comment, String
  
end
