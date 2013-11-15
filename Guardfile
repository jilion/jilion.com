group :frontend do
  guard 'livereload', host: 'jilion.dev' do
    watch(%r{^app/.+\.(erb|haml)})
    watch(%r{^app/helpers/.+\.rb})
    watch(%r{^public/javascripts/.+\.js})
    watch(%r{^public/stylesheets/.+\.css})
    watch(%r{^public/.+\.html})
    watch(%r{^config/locales/.+\.yml})
  end
end

group :backend do
  guard :rspec, all_after_pass: false, all_on_start: false, keep_failed: false do
    watch('spec/spec_helper.rb')                                  { "spec" }
    watch('app/controllers/application_controller.rb')            { "spec/controllers" }
    watch('config/routes.rb')                                     { "spec/routing" }
    watch(%r{^spec/support/(controllers|acceptance)_helpers\.rb}) { |m| "spec/#{m[1]}" }
    watch(%r{^spec/.+_spec\.rb})

    watch(%r{^app/controllers/(.+)_controller\.rb}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/controllers/#{m[1]}_controller_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }

    watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  end
end
