define :dotenv_template do
  Chef::Log.debug("Creating dotenv template definition with: #{params.inspect}")

  application = params[:application]
  deploy = params[:deploy]

  template "#{deploy['deploy_to']}/shared/config/.env" do
    source 'dotenv.erb'
    owner deploy['user']
    group deploy['group']
    mode "0660"
    variables :env => params[:env] || {}
    notifies :run, resources(:execute => "restart Rails app #{params[:application]}")

    only_if { File.exists?("#{deploy['deploy_to']}/shared/config") }
  end

end
