lock '3.2.1'

set :application, 'keywords'
set :repo_url, 'git@github.com:wangyuhere/keywords.git'
set :branch, :master
set :deploy_to, '/home/keywords'
set :scm, :git

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :linked_files, %w{config/database.yml config/secrets.yml .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :log_level, :info
set :keep_releases, 5

set :whenever_roles, [:web, :app]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  after :publishing, :restart
end
