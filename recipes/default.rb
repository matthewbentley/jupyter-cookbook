apt_update 'daily' do
  frequency 86_400
  action :periodic
end

python_runtime '3'

python_package 'jupyter'

include_recipe 'jupyter::start_notebook'
