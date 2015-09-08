# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

include_recipe 'deploy'

node[:deploy].each do |application, deploy|

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping sidekiq::deploy application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  Chef::Log.debug("Running sidekiq::setup for application #{application}")
  node.set[:opsworks][:rails_stack][:recipe] = "sidekiq::setup"
  node.set[:opsworks][:rails_stack][:restart_command] = node[:sidekiq][application][:restart_command]

  opsworks_rails do
    deploy_data deploy
    app application
  end

  Chef::Log.debug("Deploying Sidekiq Application: #{application}")
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  begin
    Chef::Log.debug("Restarting Sidekiq Application: #{application}")
    execute "restart Rails app #{application}" do
      command node[:sidekiq][application][:restart_command]
    end
  rescue Mixlib::Shellout::ShellCommandFailed
    Chef::Log.debug("Retry Sidekiq Application restart: #{application}")
    retry
  end
end
