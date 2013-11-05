#require "bundler/capistrano"

#set :stages, %w(staging production)
#set :default_stage, "production"
set :rails_env, 'production'

set :rvm_type, :user
set :rvm_ruby_version, '2.0.0'

set :application, "blog"
set :user, 'deployer'
set :deploy_via, :remote_cache
#set :use_sudo, false

set :scm, "git"
set :repo_url, "/home/deployer/repos/#{fetch(:application)}.git"
set :branch, "master"

#set :shared_path, "/home/deployer/apps/#{fetch(:application)}/shared"

set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}
#default_run_options[:pty] = true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :linked_files, %w{config/database.yml}
# set :linked_files, %w{config/database.yml}
#default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

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
      puts "Now edit the config files in #{fetch(:shared_path)}."
    end
  end
  after "deploy:updated", "deploy:setup_config"

  #task :symlink_config, roles: :app do
  #  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  #end
  #after "deploy:finalize_update", "deploy:symlink_config"

  #desc "Make sure local git is in sync with remote."
  #task :check_revision do
  #  on roles(:app) do
  #    unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #      puts "WARNING: HEAD is not the same as origin/master"
  #      puts "Run `git push` to sync changes."
  #      exit
  #    end
  #  end
  #end
  #before "deploy", "deploy:check_revision"
end

# set :application, 'my_app_name'
# set :repo_url, 'git@example.com:me/my_repo.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

#namespace :deploy do
#
#  desc 'Restart application'
#  task :restart do
#    on roles(:app), in: :sequence, wait: 5 do
#      # Your restart mechanism here, for example:
#      # execute :touch, release_path.join('tmp/restart.txt')
#    end
#  end
#
#  after :restart, :clear_cache do
#    on roles(:web), in: :groups, limit: 3, wait: 10 do
#      # Here we can do anything such as:
#      # within release_path do
#      #   execute :rake, 'cache:clear'
#      # end
#    end
#  end
#
#  after :finishing, 'deploy:cleanup'
#
#end
