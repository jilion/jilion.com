Factory.define :job, :default_strategy => :build do |c|
  c.title       "Fluent english writer"
  c.description "Job description"
end

Factory.define :contact, :default_strategy => :build do |c|
  c.sequence(:email)  { |n| "email#{n}@jilion.com" }
end

Factory.define :deal, :class => Contact::Deal, :parent => :contact, :default_strategy => :build do |c|
  c.exclusive_request true
  c.exclusive_request_business_days 20
  c.name                "Steve Jobs"
  c.phone               "+41 76 400 5101"
  c.organization        "Apple"
  c.url                 "http://apple.com"
  c.activity            "Computer Manufacturer"
  c.budget              "$1,000,000"
  c.project_description "The iPad secret project"
  c.goal                "Be the best"
  c.metrics             "What a metric"
  c.challenge           "Huge challenge"
  c.deadline            "1st of April"
  c.comment             "No comment"
end

Factory.define :contact_job, :class => Contact::Job, :parent => :contact, :default_strategy => :build do |c|
  c.message       "A message"
  c.file_filename "File"
  c.job_id        "abc123"
end

Factory.define :love, :class => Contact::Love, :parent => :contact, :default_strategy => :build do |c|
  c.message "A message"
end

Factory.define :press, :class => Contact::Press, :parent => :contact, :default_strategy => :build do |c|
  c.message "A message"
end

Factory.define :request, :class => Contact::Request, :parent => :contact, :default_strategy => :build do |c|
  c.message "A message"
end

Factory.define :team_up, :class => Contact::TeamUp, :parent => :contact, :default_strategy => :build do |c|
  c.message "A message"
end

