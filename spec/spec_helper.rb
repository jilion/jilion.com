require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] = "test"

Spork.prefork do
  
  require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
  require 'spec/autorun'
  require 'spec/rails'
  require "email_spec"
  require 'factory_girl'
  # Integration
  require 'webrat'
  require 'webrat/integrations/rspec-rails'
  
end

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

Spork.each_run do
  
  # Require factories file
  require File.dirname(__FILE__) + "/factories"
  
  # Spec Helpers
  Dir[File.join(File.dirname(__FILE__), "spec_helpers", '*.rb')].each { |file| require file }
  
  Spec::Runner.configure do |config|
    # config.include(EmailSpec::Helpers)
    # config.include(EmailSpec::Matchers)
    
    config.after(:each) do
      MongoMapper.database.collections.each { |c| c.remove }
    end
  end
  
  # Integration
  # Webrat.configure do |config|
  #   config.mode = :rails
  #   config.open_error_files = false
  # end
  
end