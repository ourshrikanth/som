require "rvm/capistrano"
require "bundler/capistrano"
require 'capistrano/ext/multistage'
# require 'sidekiq/capistrano'
require "bundler/capistrano"
require 'capistrano/sidekiq'
set :application, 'som'


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name


# Default value for :scm is :git
set :scm, :subversion

set :stages, [:development, :staging, :production]

set :use_sudo, false

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after   "deploy:update_code",    "deploy:symlink_shared"
after   "deploy:symlink_shared", "deploy:migrate"
after   "deploy:migrate",        "deploy:redis:restart"
# after   "deploy:redis:start",     "sidekiq:restart"



namespace :deploy do

  desc "Copy server specific files from shared folder to current folder"
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    # we are using release_path here just to be on safe side the current_path has not been set yet
  end

   desc "Stop Thin server"
  task :stop do
  	run "cd #{deploy_to}/current && bundle exec thin stop -e #{rails_env} --server 4 --socket #{current_path}/tmp/sockets/thin.sock"
end

  desc "Start Thin server"
  task :start do
    run "cd #{deploy_to}/current && bundle exec thin start -e #{rails_env} --server 4 --socket #{current_path}/tmp/sockets/thin.sock"
end

  desc "Restart Thin server"
  task :restart do
  	 deploy.stop
     deploy.start
  end

  namespace :redis do
  desc "Start the Redis server"
  task :start do
    begin
      run "cd #{current_path} && bundle exec redis start" 
    rescue Exception => e
      puts "***Unable to start Redis with error: #{e}"
      puts "***Continuing anyway.***"      
    end
  end

  desc "Stops the Redis server"
  task :stop do
    begin
      run "cd #{current_path} && bundle exec redis stop"
    rescue Exception => e
      puts "***Unable to stop Redis with error: #{e}"
      puts "***Continuing anyway.***"       
    end
    # run "cd #{current_path} && net stop redis"
  end

  desc "Restarts the Redis server"
  task :restart do
    redis.stop
    redis.start
  end
end


end
