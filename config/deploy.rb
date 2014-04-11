# -*- coding: utf-8 -*-
require "rvm/capistrano"
require "bundler/capistrano"
#require 'capistrano/nginx/tasks'

ssh_options[:forward_agent] = true
ssh_options[:port] = 22

set :rails_env,   "production"
set :app_env,     "production"

set :app_port, 80

set :rvm_ruby_string, "ruby-2.1.1"

set :rvm_type, :user

set :default_shell, :bash

default_run_options[:pty] = true
set :repository, "git@github.com:nedoshel/todo_angular.git"
set :scm, "git"


set :branch, 'master'

set :application, "todo_angular"

set :deploy_to, "/var/www/todo_angular"

set :thin_config, "config/thin/#{application}.yml"

set :sudo_user, :deploy

server '162.243.21.109', :app, :web, :db, primary: true

set :scm_verbose, true

set :user, "deploy"

set :rvm_bin_path, " /home/#{user}/.rvm/bin/"

set :use_sudo, false
set :keep_releases, 2


set :bundle_cmd, "/home/#{user}/.rvm/gems/#{rvm_ruby_string}@global/bin/bundle"


set :faye_pid, "#{deploy_to}/shared/pids/faye_angular.pid"



before 'deploy:migrate', 'deploy:symlink_shared'
before 'deploy:assets:precompile', 'deploy:migrate'
before 'deploy:restart', 'faye:restart'

after 'deploy:symlink_shared', 'deploy:create_db'
after 'deploy', 'deploy:cleanup'


namespace :deploy do
  desc "Restart Thin"
  task :restart, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin restart -C #{thin_config}"
  end

  desc "Start Thin"
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin start -C #{thin_config}"#
  end

  desc "Stop Thin"
  task :stop, :except => { :no_release => true } do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} #{bundle_cmd} exec thin stop -C #{thin_config}"
  end

  task :symlink_shared, :except => { :no_release => true } do
    run "mkdir -p #{shared_path}/uploads"
    run "mkdir -p #{shared_path}/assets"
    run "mkdir -p #{shared_path}/log"
    run "mkdir -p #{shared_path}/pids"

    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/log #{release_path}/log"
    run "ln -nfs #{shared_path}/pids #{release_path}/tmp/pids"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :create_db do
     run "cd #{release_path} && bundle exec rake db:create RAILS_ENV=production"
  end

  task :create_admin do
     run "cd #{release_path} && bundle exec rake admin:create RAILS_ENV=production"
  end

end

namespace :faye do
  desc "Start faye.ru server"
  task :start do
    run "cd #{release_path} && bundle exec rackup faye.ru -E production -p 9293 -s thin --pid #{faye_pid} -D"

  end

  desc "Stop faye.ru server"
  task :stop do
    run "cd #{release_path};if [ -f #{faye_pid} ] && [ -e /proc/$(cat #{faye_pid}) ]; then kill -9 `cat #{faye_pid}`; fi"
  end

  desc "Restart faye.ru server"
  task :restart do
    stop
    start
  end
end

namespace :cache do

  task :clear do
    run " cd #{deploy_to}/current && bundle exec rake tmp:cache:clear RAILS_ENV=production"
  end

end
