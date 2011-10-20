source :rubygems

gem 'rails',               '3.0.10'

gem 'haml',                '~> 3.1.1'
gem 'jammit',              '~> 0.6.0'
gem 'RedCloth',            '~> 4.2.3'
gem 'will_paginate',       '~> 3.0.0'
gem 'formtastic',          '~> 1.2.3'
gem 'fog',                 '~> 1.0.0'

gem 'bson_ext',            '~> 1.4.0'
gem 'mongo',               '~> 1.4.0'
gem 'mongoid',             '~> 2.2.0'

gem 'carrierwave',         '~> 0.5.7'
gem 'carrierwave-mongoid', '~> 0.1.1', :require => 'carrierwave/mongoid'

gem 'settingslogic', '2.0.6'

group :production do
  gem 'rack-ssl-enforcer'
  gem 'rack-no-www'
  gem 'rack-google-analytics', '0.9.2', :require => 'rack/google-analytics'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'wirble'
  gem 'heroku'

  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard-bundler'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'
end

group :test do
  gem 'spork',              '~> 0.9.0.rc3'
  gem 'database_cleaner'
  gem 'capybara'

  gem 'shoulda'
  gem 'factory_girl_rails', :require => false # loaded in spec_helper Spork.each_run
end