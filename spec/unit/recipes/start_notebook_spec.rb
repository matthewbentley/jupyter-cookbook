require 'spec_helper'

describe 'jupyter::start_notebook' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the service' do
      expect(chef_run).to create_jupyter_notebook_service('default')
    end

    it 'enables the service' do
      expect(chef_run).to enable_jupyter_notebook_service('default')
    end

    it 'starts the service' do
      expect(chef_run).to start_jupyter_notebook_service('default')
    end
  end
end
