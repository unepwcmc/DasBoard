# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'das_board'
set :repo_url, 'git@github.com:unepwcmc/DasBoard.git'
set :scm_username, "unepwcmc-read"

set :default_stage, 'staging'

require 'brightbox/recipes'
require 'brightbox/passenger'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set(:deploy_to) { File.join("", "home", user, application) }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
 set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
 
end

namespace :db do
  task :setup do
    the_host = Capistrano::CLI.ui.ask("CouchDB server IP address: ")
    port = Capistrano::CLI.ui.ask("CouchDB server port: ")
    database_name = Capistrano::CLI.ui.ask("Database name: ")
    database_user = Capistrano::CLI.ui.ask("Database username: ")
    couch_password = Capistrano::CLI.password_prompt("Database user password: ")

    require 'yaml'

    spec = {
      "#{rails_env}" => {
        "database" => database_name,
        "post" => port,
        "username" => database_user,
        "host" => the_host,
        "password" => couch_password
      }
    }

    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/database.yml")
  end
end
after "deploy:setup", 'db:setup'
