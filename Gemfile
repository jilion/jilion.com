source :rubygems

ruby '1.9.3'

gem 'bundler', '~> 1.2.0'

gem 'rails',                     '3.2.8'
gem 'validates_email_format_of', '~> 1.5.3'

gem 'haml',                '~> 3.1.1'
gem 'jammit',              '~> 0.6.0'
gem 'RedCloth',            '~> 4.2.9'
gem 'redcarpet',           '~> 1.17.2'
gem 'kaminari',            '~> 0.14.0'
gem 'formtastic',          '~> 1.2.3'
gem 'fog',                 '~> 1.0.0'

gem 'bson_ext',            '1.6.2'
gem 'bson',                '1.6.2'
gem 'mongo',               '1.6.2'
gem 'mongoid',             '~> 2.4.7'

gem 'carrierwave',         '~> 0.5.7'
gem 'carrierwave-mongoid', '~> 0.1.1', require: 'carrierwave/mongoid'

gem 'settingslogic', '2.0.6'
gem 'ratom', require: 'atom'

group :production do
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
  gem 'rack-google-analytics', '0.9.2', require: 'rack/google-analytics'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.11.0'
end

group :development do
  gem 'wirble'
  gem 'heroku'
  gem 'heroku_tasks'

  gem 'rack-livereload'

  # Guard
  gem 'terminal-notifier-guard'
  platforms :ruby do
    gem 'coolline'
  end
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
