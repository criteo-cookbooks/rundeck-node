require_relative '../spec_helper'

describe 'rundeck-node::linux' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'create group' do
    expect(chef_run).to create_group('rundeck')
  end

  it 'create user' do
    expect(chef_run).to create_user('rundeck')
  end

  it 'create home' do
    expect(chef_run).to create_directory('/home/rundeck')
  end

  it 'create sudo resource' do
    expect(chef_run).to install_sudo('rundeck-node')
  end
end
