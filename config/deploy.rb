#===========
# = CONFIG =
#===========

set :application, "jilion.com"
set :scm, :git
set :repository, "ssh://git@iscsrv56.epfl.ch/GIT/jilion_v2.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :stage, :production
set :user, "deploy"
set :use_sudo, false
set :runner, "deploy"
set :deploy_to, "/var/www/apps/#{application}"
set :app_server, :passenger
set :domain, "jilion.com"
# set :shared_database_path, "#{shared_path}/databases"
# set :shared_config_path,   "#{shared_path}/configs"

#==========
# = ROLES =
#==========

role :app, domain
role :web, domain
role :db, domain, :primary => true

# ======
# = DB =
# ======

# namespace :sqlite3 do
#   desc "Generate a database configuration file"
#   task :build_configuration, :roles => :db do
#     db_options = {
#       "adapter"  => "sqlite3",
#       "database" => "#{shared_database_path}/production.sqlite3"
#     }
#     config_options = {"production" => db_options}.to_yaml
#     put config_options, "#{shared_config_path}/sqlite_config.yml"
#   end
#  
#   desc "Links the configuration file"
#   task :link_configuration_file, :roles => :db do
#     run "ln -nsf #{shared_config_path}/sqlite_config.yml #{release_path}/config/database.yml"
#     # run "ln -nsf #{shared_database_path}/production.sqlite3 #{release_path}/db/production.sqlite3" 
#   end
#  
#   desc "Make a shared folders"
#   task :make_shared_folders, :roles => :db do
#     run "mkdir -p #{shared_database_path}"
#     run "mkdir -p #{shared_config_path}"
#   end
# end

after "deploy:symlink", "db:symlink"

namespace :db do
  task :symlink do
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    run "ln -nsf #{shared_path}/medias #{release_path}/public/medias"
  end
end

#===========
# = CUSTOM =
#===========

namespace :deploy do
  
task :start, :roles => :app do
  run "touch #{current_release}/tmp/restart.txt"
end
task :stop, :roles => :app do
# Do nothing.
end
desc "Restart Application"
task :restart, :roles => :app do
  run "touch #{current_release}/tmp/restart.txt"
end
end