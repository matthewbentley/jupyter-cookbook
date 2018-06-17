property :username, String, default: 'jupyter'
property :groupname, String, default: 'jupyter'
property :service_name, String, name_property: true
property :ip, String, default: 'localhost'
property :port, Int, default: 8888

action :create do
  group new_resource.groupname do
    system true
  end

  user new_resource.username do
    group new_resource.groupname
    home "/home/#{new_resource.username}"
    manage_home true
    system true
    shell '/bin/bash'
  end

  directory '/usr/lib/systemd/system/' do
    owner 'root'
    group 'root'
  end

  directory "/home/#{new_resource.username}/notebooks" do
    group new_resource.groupname
    user new_resource.username
  end

  template "/usr/lib/systemd/system/jupyter-#{new_resource.service_name}.service" do
    source 'jupyter.service.erb'
    variables(
      service_name: new_resource.service_name,
      user: new_resource.username,
      group: new_resource.groupname,
      ip: new_resource.ip,
      port: new_resource.port,
    )
    owner 'root'
    group 'root'
    mode '0644'
    action :create
  end
end

[:enable, :start].each do |proxy_action|
  action proxy_action do
    service "jupyter-#{new_resource.service_name}" do
      action proxy_action
    end
  end
end
