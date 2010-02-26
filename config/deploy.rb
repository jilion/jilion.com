#===========
# = CONFIG =
#===========

set :application, "jilion.com"
set :scm, :git
set :repository, "git@jime1.epfl.ch:jilion_v2.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
# set :deploy_via, :remote_cache
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

after "deploy:symlink", "db:symlink"
before "deploy:symlink", "asset:prepare"
after "asset:prepare", "asset:copyright"
after "asset:copyright", "asset:upload"

namespace :asset do
  task :prepare do
    run "cd #{release_path}; jammit -u http://jilion.com"
  end
  
  task :copyright do
    run "cd #{release_path}; rake copyright:add_to_top RAILS_ENV=production"
  end
  
  task :upload do
    run "cd #{release_path}; rake cdn:assets:upload RAILS_ENV=production"
  end
end

namespace :db do
  task :symlink do
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    # run "ln -nsf #{shared_config_path}/mysql_config.yml #{release_path}/config/database.yml"
    run "ln -nsf #{shared_path}/medias #{release_path}/public/medias"
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