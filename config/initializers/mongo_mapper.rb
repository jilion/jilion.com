# load db settings
db_config = YAML::load(File.read("#{Rails.root}/config/database.yml"))

# connect to the db
if db_config[Rails.env] && db_config[Rails.env]['adapter'] == 'mongodb'
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new((mongo['hostname'] || 'localhost'), (mongo['port'] || 27017), :slave_ok => true)
  MongoMapper.database   = mongo['database']
end