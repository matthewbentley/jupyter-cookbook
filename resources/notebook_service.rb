property :username, String, default: 'jupyter'
property :groupname, String, default: 'jupyter'
property :service_name, String, name_property: true
property :ip, String, default: 'localhost'
property :port, Integer, default: 8888

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

  directory "/home/#{new_resource.username}/notebooks" do
    group new_resource.groupname
    user new_resource.username
  end

  systemd_unit "jupyter-#{new_resource.service_name}.service" do
    content(
      Unit: {
        Description: 'Jupyter Notebook',
        After: 'network.target',
      },
      Service: {
        Type: 'simple',
        PIDFile: "/run/jupyter-#{new_resource.service_name}.pid",
        ExecStart: "/usr/local/jupyter-notebook --no-browser --ip=#{new_resource.ip} --port=#{new_resource.port}",
        User: new_resource.username,
        Group: new_resource.groupname,
        Restart: 'always',
        RestartSec: 10,
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
    )
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
