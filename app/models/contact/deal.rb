class Contact::Deal < Contact

  field :exclusive_request,               :type => Boolean
  field :exclusive_request_business_days, :type => Integer
  field :name,                            :type => String
  field :phone,                           :type => String
  field :organization,                    :type => String
  field :url,                             :type => String
  field :activity,                        :type => String
  field :budget,                          :type => String
  field :project_description,             :type => String
  field :goal,                            :type => String
  field :metrics,                         :type => String
  field :challenge,                       :type => String
  field :deadline,                        :type => String
  field :comment,                         :type => String

  # validates_inclusion_of :exclusive_request, :within => %w( true false ), :message => "is required"
  validates_presence_of :name
  validates_presence_of :activity
  validates_presence_of :budget
  validates_presence_of :project_description

  # def exclusive_request_business_days=(days)
  #   @exclusive_request_business_days = days if exclusive_request?
  # end
  # 
  # def exclusive_request?
  #   exclusive_request
  # end

end
