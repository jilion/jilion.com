FactoryGirl.define do

  factory :job do
    title       "Fluent english writer"
    summary     "Job summary"
    description "Job description"
  end

  factory :contact do
    sequence(:email)  { |n| "email#{n}@jilion.com" }
    message  'A message'
  end

  factory :contact_job, :class => Contact::Job, parent: :contact do
    file { File.new(Rails.root.join('spec/fixtures/How to Name Gems.pdf')) }
    job
  end

  factory :press, :class => Contact::Press, parent: :contact do
  end

  factory :request, :class => Contact::Request, parent: :contact do
  end

  factory :team_up, :class => Contact::TeamUp, parent: :contact do
  end

end
