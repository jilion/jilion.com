source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 3.2.15'
gem 'rails_12factor'

gem 'bson_ext', '~> 1.9'
gem 'bson',     '~> 1.9'
gem 'mongo',    '~> 1.9'
gem 'mongoid',  '~> 2.7.0'

gem 'validates_email_format_of'
gem 'has_scope'
gem 'haml'
gem 'haml-contrib'
gem 'RedCloth'
gem 'kaminari'
gem 'formtastic'
gem 'oj'

gem 'fog'
gem 'carrierwave', require: ['carrierwave', 'carrierwave/processing/mime_types']
gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'

gem 'ratom', require: 'atom'

gem 'rack-status'
gem 'newrelic_rpm'
gem 'honeybadger'

group :production do
  gem 'rack-google-analytics', '~> 0.12'
end

group :staging, :production do
  gem 'unicorn'
  gem 'lograge'
  gem 'memcachier'
  gem 'dalli'
  gem 'rack-cache'
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
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
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'poltergeist'

  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
