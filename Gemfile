source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails',                     '3.2.13'

gem 'validates_email_format_of'
gem 'has_scope'
gem 'haml'
gem 'haml-contrib'
gem 'RedCloth'
gem 'kaminari'
gem 'formtastic'
gem 'fog'
gem 'oj'

gem 'bson_ext',            '1.8.4'
gem 'bson',                '1.8.4'
gem 'mongo',               '1.8.4'
gem 'mongoid',             '~> 2.7.0'

gem 'carrierwave'
gem 'carrierwave-mongoid', '~> 0.2.2', require: 'carrierwave/mongoid'

gem 'settingslogic', '2.0.6'
gem 'ratom', require: 'atom'

group :production do
  gem 'rack-google-analytics', '0.9.2', require: 'rack/google-analytics'
end

group :staging, :production do
  gem 'unicorn'
  gem 'dalli'
  gem 'rack-cache'
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'rack-livereload'

  # Guard
  gem 'growl'
  gem 'rb-fsevent'

  gem 'guard-rspec'
  gem 'guard-livereload'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'

  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
