require 'spec_helper'

describe 'rundeck-node::local_user' do

  let(:windows_chef_run) { ChefSpec::SoloRunner.new(WINDOWS_OHAI).converge(described_recipe) }
  let(:linux_chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'creates group with rundeck user in it' do
    expect(windows_chef_run).to create_group('Administrators').with(members: ['rundeck'])
    expect(linux_chef_run).to create_group('rundeck').with(members: ['rundeck'])
  end

  it 'creates user' do
    expect(windows_chef_run).to create_user('rundeck')
    expect(linux_chef_run).to create_user('rundeck')
  end

  describe 'on Linux' do
    it 'creates sudo resource' do
      expect(linux_chef_run).to install_sudo('rundeck-node')
    end
  end
end
