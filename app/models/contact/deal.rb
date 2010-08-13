class Contact::Deal < Contact
  
  key :exclusive_request, Boolean
  key :exclusive_request_business_days, Integer
  key :name, String, :required => true
  key :phone, String
  key :organization, String
  key :url, String
  key :activity, String, :required => true
  key :budget, String, :required => true
  key :project_description, String, :required => true
  key :goal, String
  key :metrics, String
  key :challenge, String
  key :deadline, String
  key :comment, String
  
  # validates_inclusion_of :exclusive_request, :within => %w( true false ), :message => "is required"
  
  def exclusive_request_business_days=(days)
    @exclusive_request_business_days = days if exclusive_request?
  end
  
  # def exclusive_request?
  #   exclusive_request == "true"
  # end
  
end