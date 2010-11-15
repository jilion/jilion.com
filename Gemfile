source :rubygems

gem 'rails',             '~> 3.0.1'

gem 'i18n',              '~> 0.4.1'
gem 'haml',              '~> 3.0.23'
gem 'jammit',            '~> 0.5.4'
# gem 'jammit',            :git => 'git://github.com/thibaudgg/jammit.git'

group :production do
  gem 'rack-google-analytics', '~> 0.9.2', :require => 'rack/google-analytics'
end

group :development do
  gem 'wirble' # irbrcg
  gem 'heroku',        '~> 1.12.2'
  gem 'heroku_tasks',  '~> 0.1.4'
end

group :test do
  gem 'growl'
  gem 'guard'
  gem 'rb-fsevent',         '~> 0.3.9'
  gem 'guard-rspec'
  gem 'guard-passenger'
  gem 'guard-bundler'
  gem 'guard-ego'
end