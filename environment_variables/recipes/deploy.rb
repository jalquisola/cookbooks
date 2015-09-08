# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107
node[:deploy].each do |application, deploy|
  next unless deploy[:application_type]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  if deploy[:environment] && deploy[:environment].any?
    deploy[:environment].each do |key, value|
      Chef::Log.info("Setting ENV[#{key}] to #{value}")
      ENV[key] = value
    end
  end

  directory "#{deploy[:deploy_to]}/shared/config" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    action :create
    recursive true
  end

  dotenv_template do
    application application
    deploy deploy
    env deploy[:environment]
  end
end