class Contact::Deal < Contact
  
  key :name, String
  key :phone, String
  key :organization, String
  key :url, String
  key :activity, String
  key :budget, String
  key :project_description, String
  key :goal, String
  key :metrics, String
  key :challenge, String
  key :deadline, String
  key :comment, String
  
  validates_presence_of :budget, :message => "can't be blank"
  
end
