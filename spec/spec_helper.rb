require 'rubygems'
require 'spork'
ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require File.dirname(__FILE__) + "/../config/environment"
  require 'rspec/rails'

  RSpec.configure do |config|
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.mock_with :rspec
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, comment the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = false

    # config.before(:suite) do
    #   DatabaseCleaner[:active_record].strategy = :transaction
    #   DatabaseCleaner[:mongoid].strategy       = :truncation
    #   DatabaseCleaner.clean_with(:truncation) # clean all the databases
    # end

    config.before(:each) do
      Capybara.reset_sessions!
      # DatabaseCleaner.start
    end

    # Clear MongoDB Collection
    config.after(:each) do
      # DatabaseCleaner.clean
      Mongoid.master.collections.select { |c| c.name !~ /system/ }.each(&:drop)
    end
    #
    # config.after(:all) do
    #   DatabaseCleaner.clean_with(:truncation) # clean all the databases
    # end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Needed to prevent all models loaded by Mongoid
  Rails::Mongoid.load_models(Jilion::Application)

  # Needed to prevent routes.rb to be load on Rails initialization and make User/Admin model loaded by devise_for
  Jilion::Application.reload_routes!

  # Reload yml locales
  I18n.reload!

  # Factory need to be required each launch to prevent loading of all models
  require 'factory_girl'
  require Rails.root.join("spec/factories")

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.include Shoulda::ActionController::Matchers
    config.include Capybara
    # config.include Devise::TestHelpers, :type => :controller
  end
end
