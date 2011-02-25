Factory.define :job, :default_strategy => :build do |c|
  c.title       "Fluent english writer"
  c.summary     "Job summary"
  c.description "Job description"
end

Factory.define :contact, :default_strategy => :build do |c|
  c.sequence(:email)  { |n| "email#{n}@jilion.com" }
end

Factory.define :contact_job, :class => Contact::Job, :parent => :contact, :default_strategy => :build do |c|
  c.message "A message"
  c.file    { File.new(Rails.root.join('spec/fixtures/How to Name Gems.pdf')) }
  c.job_id  "abc123"
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

