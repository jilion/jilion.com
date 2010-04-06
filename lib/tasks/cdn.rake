require 'right_aws'

namespace :cdn do
  namespace :assets do
    desc "Upload static assets to S3"
    task :upload => :environment do
      timestamp = Time.now.strftime("%m%d%Y%H%M%S")
      
      %x[jammit -u https://s3.amazonaws.com/jilion.com/#{timestamp} -f]
      
      # Add paths here from assets which are not processed by jammit but you want to put on the CDN
      %x[cp public/javascripts/sublime/video/sublime.js public/assets/sublime.js]
      %x[cp public/javascripts/curvycorners.js public/assets/curvycorners.js]
      
      files = ["public/assets/style.css","public/assets/style-datauri.css","public/assets/style-mhtml.css"]
      
      files.each do |file|
        buffer = File.new(file,'r').read.gsub(/@media screen and\(/,"@media screen and (").gsub(/\/images\/embed/,"/#{timestamp}/images/embed")
        File.open(file,'w') {|fw| fw.write(buffer)}
      end
      
      files = ["public/assets/sublime_ie7.css","public/assets/sublime_ie6.css"]
      
      files.each do |file|
        buffer = File.new(file,'r').read.gsub(/\/images\/embed/,"https://s3.amazonaws.com/jilion.com/#{timestamp}/images/embed")
        File.open(file,'w') {|fw| fw.write(buffer)}
      end
      
      buffer = File.new("public/assets/sublime.js",'r').read.gsub(/\/images\/embed\/sublime\/video\/play_button.png/,"http://assets0.jilion.com/#{timestamp}/images/embed/sublime/video/play_button.png").gsub(/\/flash\/sublime.swf/,"http://assets0.jilion.com/#{timestamp}/flash/sublime.swf")
      File.open("public/assets/sublime.js",'w') {|fw| fw.write(buffer)}
      
      s3 = RightAws::S3.new(
        S3_CONFIG['access_key_id'],
        S3_CONFIG['secret_access_key']
      )
      bucket = s3.bucket(S3_CONFIG['bucket'], true, 'public-read')
      
      files = Dir.glob(File.join(RAILS_ROOT, "public/assets/*")) +
              Dir.glob(File.join(RAILS_ROOT, "public/images/**/*.{png,jpg,jpeg,gif}")) +
              Dir.glob(File.join(RAILS_ROOT, "public/flash/*"))
      
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
ActionController::Base.asset_host = Proc.new { |source, request|
  if request.ssl?
    "\#{request.protocol}s3.amazonaws.com/jilion.com/#{timestamp}"
  else
    "\#{request.protocol}assets\#{rand(4)}.jilion.com/#{timestamp}"
  end
}
EOT
      config_file.close
      puts "Successfully added the new assets CDN location to production.rb"
    end
  end
end