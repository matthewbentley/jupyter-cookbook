jupyter_notebook_service 'default' do
  action [:create, :enable, :start]
  ip node['ipaddress']
end
