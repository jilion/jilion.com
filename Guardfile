guard 'bundler' do
  watch('^Gemfile')
end

guard 'passenger', :port => 3001 do
  # watch('^lib/.*\.rb$')
  watch('^config/application.rb$')
  watch('^config/environment.rb$')
  watch('^config/environments/.*\.rb$')
  watch('^config/initializers/.*\.rb$')
end

guard 'rspec', :version => 2, :drb => true, :bundler => false, :formatter => "instafail", :fail_fast => true do
  watch('^spec/spec_helper.rb')                       { "spec" }
  watch('^spec/factories.rb')                         { "spec/models" }
  watch('^app/controllers/application_controller.rb') { "spec/controllers" }
  watch('^spec/support/controller_helpers.rb')        { "spec/controllers" }
  watch('^spec/support/acceptance_helpers.rb')        { "spec/acceptance" }
  watch('^config/routes.rb')                          { "spec/routing" }
  watch('^spec/(.*)_spec.rb')
  watch('^app/(.*)\.rb')                              { |m| "spec/#{m[1]}_spec.rb" }
  watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
end