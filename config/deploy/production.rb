set :stage, :production

server "200.134.18.125", roles: %w{web app db}, user: 'deployer', primary: true

set :ssh_options, {
  forward_agent: true,
  port: 22126,
}

set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
fetch(:default_env).merge!(rails_env: :production)
