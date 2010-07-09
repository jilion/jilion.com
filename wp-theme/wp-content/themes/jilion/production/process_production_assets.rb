require 'rubygems'
require 'ftools'
require 'aws/s3'

timestamp = Time.now.strftime("%m%d%Y%H%M%S")

%x[cd ..;jammit -c assets.yml -o production/assets -u http://blog.medias.jilion.com/#{timestamp} -f]

files = ["assets/style.css","assets/style-datauri.css","assets/style-mhtml.css"]

files.each do |file|
  buffer = File.new(file,'r').read.gsub(/@media screen and\(/,"@media screen and (")
  File.open(file,'w') {|fw| fw.write(buffer)}
end

puts "Jammited CSSs had been cleaned to work with modern browsers"

AWS::S3::Base.establish_connection!(
  :access_key_id     => '0BNK5HS36QFNVCVRBBG2',
  :secret_access_key => 'zGODjlVgFrfcvNfqDo7aMBMUrpQsvY+mIBwpf+lQ'
)

files = Dir.glob(File.join("assets/*")) +
         Dir.glob(File.join("../images/*.{png,jpg,jpeg,gif}"))
         
files.each do |file|
  filekey = file.gsub(/\.\.\//,'')
  filekey = "#{timestamp}/#{filekey}"
  $stdout.print('.')
  $stdout.flush
  AWS::S3::S3Object.store(filekey, open(file), 'blog.jilion.com', :access => :public_read)
end

puts "Finished uploaded assets on Amazon S3"

header_file = "header_sample.php"
buffer = File.new(header_file,'r').read.gsub(/\/assets\/style-datauri.css/,"http://blog.medias.jilion.com/#{timestamp}/assets/style-datauri.css").gsub(/\/assets\/style-mhtml.css/,"http://blog.medias.jilion.com/#{timestamp}/assets/style-mhtml.css")
File.open('header.php','w') {|fw| fw.write(buffer)}
puts "Good job! header.php is ready to be uploaded."