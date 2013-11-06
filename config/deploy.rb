set :rails_env, 'production'

set :rvm_type, :user
set :rvm_ruby_version, '2.0.0'

set :application, "blog"
set :user, 'deployer'
set :deploy_via, :remote_cache

set :scm, "git"
set :repo_url, "/home/deployer/repos/#{fetch(:application)}.git"
set :branch, "master"

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :normalize_asset_timestamps, false

set :format, :pretty
set :log_level, :info

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end

  task :setup_config do
    on roles(:app) do
      within current_path do
        sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}.conf"
        sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      end
      puts "Now edit the config files in #{shared_path}."
    end
  end
  before "deploy:restart", "deploy:setup_config"

end
