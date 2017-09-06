require 'spec_helper'

describe 'jupyter::default' do
  context 'When all attributes are default, on an Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'sets up regular apt updates' do
      expect(chef_run).to periodic_apt_update('daily')
    end

    it 'installs python' do
      expect(chef_run).to install_python_runtime('3')
    end

    it 'installs jupyter' do
      expect(chef_run).to install_python_package('jupyter')
    end

    it 'includes the recipe to start a notebook server' do
      expect(chef_run).to include_recipe('jupyter::start_notebook')
    end
  end
end
