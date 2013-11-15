source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0.1'

gem 'mongoid', github: 'mongoid'
gem 'moped', github: 'mongoid/moped', branch: 'auth_connection_pool'

gem 'validates_email_format_of'
gem 'has_scope'

# Views
gem 'haml'
gem 'haml-contrib'
gem 'coffee-rails'
gem 'RedCloth'

gem 'kaminari'
gem 'formtastic'
gem 'oj'

gem 'fog'
gem 'unf' # encoding for fog
gem 'carrierwave', require: ['carrierwave', 'carrierwave/processing/mime_types']
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'

gem 'ratom', require: 'atom'

# Monitoring
gem 'rack-status'
gem 'honeybadger'

gem 'sass-rails'
gem 'uglifier'

group :production do
  gem 'rack-google-analytics', github: 'leehambley/rack-google-analytics'
end

group :staging, :production do
  gem 'unicorn', require: false
  gem 'rails_12factor'
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
  gem 'memcachier'
  gem 'dalli'
  gem 'rack-cache'
  gem 'lograge'
  gem 'newrelic_rpm'
  gem 'newrelic_moped'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'

  # Guard
  gem 'ruby_gntp', require: false
  gem 'guard-livereload', require: false
  gem 'guard-rspec', require: false
end

group :development do
  gem 'rack-livereload'

  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'

  gem 'shoulda'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
