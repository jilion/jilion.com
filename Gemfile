source :rubygems

gem 'rake',          '0.8.7'
gem 'bundler',       '1.0.13'

gem 'rails',         '3.0.7'
gem 'haml',          '3.1.1'
gem 'jammit',        '0.6.0'
gem 'RedCloth',      '4.2.3'
gem 'will_paginate', '3.0.pre2'
gem 'formtastic',    '1.2.3'
gem 'fog',           '0.7.2'
gem 'carrierwave',   '0.5.3'
gem 'bson_ext',      '1.3.0'
gem 'mongo',         '1.3.0'
gem 'mongoid',       '2.0.1'

gem 'settingslogic', '2.0.6'

group :production do
  gem 'rack-ssl-enforcer', '0.2.2'
  gem 'rack-google-analytics', '0.9.2', :require => 'rack/google-analytics'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'passenger'
end

group :development do
  gem 'wirble'
  gem 'heroku'
  gem 'heroku_tasks'
end

group :test do
  gem 'growl'
  gem 'spork',              '~> 0.9.0.rc3'
  gem 'rb-fsevent'
  gem 'guard-ego'
  gem 'guard-bundler'
  gem 'guard-passenger'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-livereload'

  gem 'database_cleaner'
  gem 'steak',              '1.0.0.rc.2'
  gem 'capybara'

  gem 'shoulda'
  gem 'factory_girl_rails', :require => false # loaded in spec_helper Spork.each_run
end