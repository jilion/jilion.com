source :rubygems

# gem 'rails',         '~> 3.0.3'
gem 'rails',         :git => 'git://github.com/thibaudgg/rails.git', :branch => 'spork' # 3.0.3
gem 'i18n',          '0.5.0'
gem 'haml',          '3.0.24'
gem 'jammit',        '0.6.0'
gem 'will_paginate', '3.0.pre2'
gem 'formtastic',    '1.2.3'
gem 'fog',           '0.4.1'
gem 'carrierwave',   '0.5.1'
gem 'bson_ext',      '1.2.0'
gem 'mongo',         '1.2.0'
# gem 'mongoid',       '~> 2.0.0.beta.20'
gem 'mongoid',       :git => 'git://github.com/thibaudgg/mongoid.git', :branch => 'spork' # 2.0.0.beta.20
gem 'prawn',         '0.8.4'

group :production do
  gem 'rack-google-analytics', '0.9.2', :require => 'rack/google-analytics'
end

group :development, :test do
  gem 'rspec-rails',   '~> 2.4.1'
  gem 'passenger',     '~> 3.0.2'
end

group :development do
  gem 'wirble',        '~> 0.1.3'
  gem 'heroku',        '~> 1.17.10'
  gem 'heroku_tasks',  '~> 0.1.4'
end

group :test do
  gem 'growl'
  gem 'spork',              '~> 0.9.0.rc2'
  gem 'rb-fsevent',         '~> 0.3.9'
  gem 'guard'
  gem 'guard-ego'
  gem 'guard-bundler'
  gem 'guard-passenger'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'livereload'
  gem 'guard-livereload'

  gem 'database_cleaner',   '>= 0.6'
  gem 'steak',              '1.0.0.rc.2'
  gem 'capybara',           '~> 0.4.1.1'

  gem 'shoulda',            '~> 2.11.3'
  gem 'factory_girl_rails', '~> 1.0.1', :require => false # loaded in spec_helper Spork.each_run
end