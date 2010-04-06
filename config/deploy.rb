#===========
# = CONFIG =
#===========

set :application, "jilion.com"
set :scm, :git
set :repository, "git@jime1.epfl.ch:jilion.com.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :stage, :production
set :user, "deploy"
set :use_sudo, false
set :runner, "deploy"
set :deploy_to, "/var/www/apps/#{application}"
set :app_server, :passenger
set :domain, "jilion.com" # li64-176.members.linode.com
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

after "deploy:symlink", "db:symlink"
before "deploy:symlink", "asset:upload"

namespace :asset do
  task :upload do
    run "cd #{release_path}; rake cdn:assets:upload RAILS_ENV=production"
  end
end

namespace :db do
  task :symlink do
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    run "ln -nsf #{shared_path}/media #{release_path}/public/media"
    run "ln -nsf #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nsf #{shared_path}/test #{release_path}/public/test"
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