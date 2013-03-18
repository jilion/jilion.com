source 'https://rubygems.org'

ruby '1.9.3'

gem 'bundler'

gem 'rails',                     '3.2.13'
gem 'validates_email_format_of', '~> 1.5.3'

gem 'has_scope',           '~> 0.5.1'
gem 'haml',                '~> 3.1.1'
gem 'RedCloth',            '~> 4.2.9'
gem 'redcarpet',           '~> 1.17.2'
gem 'kaminari',            '~> 0.14.0'
gem 'formtastic',          '~> 1.2.3'
gem 'fog',                 '~> 1.0.0'
gem 'json'

gem 'bson_ext',            '1.6.2'
gem 'bson',                '1.6.2'
gem 'mongo',               '1.6.2'
gem 'mongoid',             '~> 2.4.7'

gem 'carrierwave',         '~> 0.5.7'
gem 'carrierwave-mongoid', '~> 0.1.1', require: 'carrierwave/mongoid'

gem 'settingslogic', '2.0.6'
gem 'ratom', require: 'atom'

group :production do
  gem 'rack-google-analytics', '0.9.2', require: 'rack/google-analytics'
end

group :staging, :production do
  gem 'thin'
  gem 'dalli'
  gem 'rack-cache'
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
  gem 'newrelic_rpm'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.11.0'
end

group :development do
  gem 'wirble'
  gem 'heroku'
  gem 'rack-livereload'

  # Guard
  gem 'growl'
  gem 'rb-fsevent'

  gem 'guard-bundler'
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
