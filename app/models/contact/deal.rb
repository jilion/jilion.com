class Contact::Deal < Contact
  
  key :exclusive_request, String
  key :exclusive_request_business_days, Integer
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
  
  validates_inclusion_of :exclusive_request, :within => %w( true false ), :message => "is required"
  validates_presence_of :name, :message => "can't be blank"
  validates_presence_of :activity, :message => "can't be blank"
  validates_presence_of :budget, :message => "can't be blank"
  validates_presence_of :project_description, :message => "can't be blank"
  
  def exclusive_request_business_days=(days)
    @exclusive_request_business_days = days if exclusive_request?
  end
  
  def exclusive_request?
    exclusive_request == "true"
  end
  
end
