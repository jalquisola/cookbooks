# Set up app's custom configuration in the environment.
# See https://forums.aws.amazon.com/thread.jspa?threadID=118107
node[:deploy].each do |application, deploy|
  next unless deploy[:application_type]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  Chef::Log.info("Deploy: #{deploy.inspect}")
  Chef::Log.info("node[:deploy]: #{node[:deploy].inspect}")
  directory "#{deploy[:deploy_to]}/shared/config" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    action :create
    recursive true
  end


  template "#{deploy['deploy_to']}/shared/config/secrets.yml" do
    source 'secrets.yml.erb'
    owner deploy['user']
    group deploy['group']
    mode "0660"
    variables :secrets => deploy[:secrets], :environment => deploy[:rails_env]
    notifies :run, resources(:execute => "restart Rails app #{application}")

    only_if { File.exists?("#{deploy['deploy_to']}/shared/config") }
  end
end
