set :rails_env, "staging"

set :domain, "unepwcmc-011.vm.brightbox.net"
server "unepwcmc-011.vm.brightbox.net", :app, :web, :db, :primary => true

set :application, "dasboard"
set :server_name, "dasboard.unepwcmc-011.vm.brightbox.net"
set :sudo_user, "rails"
set :app_port, "80"
