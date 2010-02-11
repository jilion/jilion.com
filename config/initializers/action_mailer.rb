ENV_HOST = {'development' => 'jilion.com.local', 'test' => 'localhost:3000', 'production' => 'jilion.com' }
ActionMailer::Base.default_url_options = { :host => ENV_HOST[Rails.env] }
ActionMailer::Base.template_root = "#{Rails.root}/app/mails"

mailer_config = File.open("#{Rails.root}/config/mailer.yml")
mailer_options = YAML.load(mailer_config)
ActionMailer::Base.smtp_settings = mailer_options
