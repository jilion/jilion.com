require 'right_aws'

namespace :cdn do
  namespace :assets do
    desc "Upload static assets to S3"
    task :upload => :environment do
      timestamp = Time.now.strftime("%m%d%Y%H%M%S")
      
      %x[jammit -u http://assets1.jilion.com/#{timestamp} -f]
      
      # Add paths here from assets which are not processed by jammit but you want to put on the CDN
      %x[cp public/javascripts/sublime/video/sublime.js public/assets/sublime.js]
      %x[cp public/stylesheets/sublime/video/ie7.css public/assets/ie7.css]
      %x[cp public/stylesheets/sublime/video/ie6.css public/assets/ie6.css]
      
      s3 = RightAws::S3.new(
        S3_CONFIG['access_key_id'],
        S3_CONFIG['secret_access_key']
      )
      bucket = s3.bucket(S3_CONFIG['bucket'], true, 'public-read')
      
      files = Dir.glob(File.join(RAILS_ROOT, "public/assets/*")) +
              Dir.glob(File.join(RAILS_ROOT, "public/images/**/*.{png,jpg,jpeg,gif}"))
      
      files.each do |file|
        filekey = file.gsub(/.*public\//, "#{timestamp}/")
        key = bucket.key(filekey)
        # $stdout.print('.')
        # $stdout.flush
        begin
          File.open(file) do |f|
            key.data = f
            key.put(nil, 'public-read', {'Expires' => 1.year.from_now})
          end
        rescue RightAws::AwsError => e
          puts "Couldn't save #{key}"
          puts e.message
          puts e.backtrace.join("\n")
        end
      end
      puts "Finished uploaded assets on Amazon S3"
      config_file = File.open( File.join( RAILS_ROOT , 'config/environments', 'production.rb' ), "a+" )
      config_file << 
<<-EOT

# overriding production.rb to include new asset host:
ActionController::Base.asset_host = Proc.new { |source|
  "http://assets\#{rand(4)}.jilion.com/#{timestamp}"
}
EOT
      config_file.close
      puts "Successfully added the new assets CDN location to production.rb"
    end
  end
end