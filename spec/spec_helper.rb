require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] = "test"

Spork.prefork do
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec'
  require 'spec/rails'
  # require 'email_spec'
  require 'factory_girl'
  require 'capybara'
  # require 'webrat/integrations/rspec-rails'
end

Spork.each_run do
  require File.dirname(__FILE__) + "/factories"
  
  Dir[Rails.root.join('/spec/support/**/*.rb')].each { |f| require f }
  
  Spec::Runner.configure do |config|
    # config.include(EmailSpec::Helpers)
    # config.include(EmailSpec::Matchers)
    
    config.after(:each) do
      MongoMapper.database.collections.each { |c| c.remove }
    end
  end
  
  # Webrat.configure do |config|
  #   config.mode = :rails
  #   config.open_error_files = false
  # end
end