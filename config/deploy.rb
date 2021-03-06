set :default_stage, 'staging'
require 'capistrano/ext/multistage'

require 'brightbox/recipes'
require 'brightbox/passenger'

set :rake, 'bundle exec rake'

set :generate_webserver_config, false

ssh_options[:forward_agent] = true

set :rvm_ruby_string, '2.0.0'

# Load RVM's capistrano plugin.
require 'rvm/capistrano'

# The name of your application.  Used for deployment directory and filenames
# and Apache configs. Should be unique on the Brightbox
set :application, "dasboard"

# Target directory for the application on the web and app servers.
set(:deploy_to) { File.join("", "home", user, application) }

set :repository,  "git@github.com:unepwcmc/DasBoard.git"
set :scm, :git
set :scm_username, "unepwcmc-read"
set :deploy_via, :remote_cache

## Local Shared Area
# These are the list of files and directories that you want
# to share between the releases of your application on a particular
# server. It uses the same shared area as the log files.
#
# NOTE: local areas trump global areas, allowing you to have some
# servers using local assets if required.
#
# So if you have an 'upload' directory in public, add 'public/upload'
# to the :local_shared_dirs array.
# If you want to share the database.yml add 'config/database.yml'
# to the :local_shared_files array.
#
# The shared area is prepared with 'deploy:setup' and all the shared
# items are symlinked in when the code is updated.
set :local_shared_files, %w(config/database.yml)

# If you are not using the brightbox gem, uncomment out the following so
# that the dotenv file is symlinked correctly.
#require "dotenv/capistrano"

# Forces a Pty so that svn+ssh repository access will work. You
# don't need this if you are using a different SCM system. Note that
# ptys stop shell startup scripts from running.
default_run_options[:pty] = true

namespace :db do
  task :setup do
    the_host = Capistrano::CLI.ui.ask("Database IP address: ")
    database_name = Capistrano::CLI.ui.ask("Database name: ")
    database_user = Capistrano::CLI.ui.ask("Database username: ")
    pg_password = Capistrano::CLI.password_prompt("Database user password: ")

    require 'yaml'

    spec = {
      "#{rails_env}" => {
        "adapter" => "postgresql",
        "database" => database_name,
        "username" => database_user,
        "host" => the_host,
        "password" => pg_password
      }
    }

    run "mkdir -p #{shared_path}/config"
    put(spec.to_yaml, "#{shared_path}/config/database.yml")
  end
end
after "deploy:setup", 'db:setup'

namespace :deploy do
  desc "Tell Passenger to restart the app."
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "Configure VHost"
task :config_vhost do
  vhost_config = <<-EOF
    server {
      server_name #{server_name};
      listen 80;

      client_max_body_size 4G;
      gzip on;
      keepalive_timeout 5;
      root #{deploy_to}/current/public;

      passenger_enabled on;
      rails_env #{rails_env};

      add_header 'Access-Control-Allow-Origin' *;
      add_header 'Access-Control-Allow-Methods' "GET, POST, PUT, DELETE, OPTIONS";
      add_header 'Access-Control-Allow-Headers' "X-Requested-With, X-Prototype-Version";
      add_header 'Access-Control-Max-Age' 1728000;

      location ^~ /assets/ {
        expires max;
        add_header Cache-Control public;
      }

      if (-f $document_root/system/maintenance.html) {
        return 503;
      }

      error_page 500 502 504 /500.html;
      location = /500.html {
        root #{deploy_to}/public;
      }

      error_page 503 @maintenance;
      location @maintenance {
        rewrite  ^(.*)$  /system/maintenance.html break;
      }
    }
  EOF

  put vhost_config, "/tmp/vhost_config"
  sudo "mv /tmp/vhost_config /etc/nginx/sites-available/#{application}"
  sudo "ln -s /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"
end
after "deploy:setup", :config_vhost

# run like: cap staging rake_invoke task=a_certain_task
task :rake_invoke do
  run("cd #{deploy_to}/current; bundle exec /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
end

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end
