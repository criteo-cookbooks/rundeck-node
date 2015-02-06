require 'spec_helper'

describe 'rundeck-node::default' do


  def linux_chef_run(attributes = {})
    ChefSpec::SoloRunner.new do |node|
      node.set['rundeck_node'] = attributes
    end.converge described_recipe
  end

  it 'includes rundeck-node::local_user recipe when account is local' do
    expect(windows_chef_run_with_cert(true, account: 'local')).to include_recipe('rundeck-node::local_user')
    expect(linux_chef_run(account: 'local')).to include_recipe('rundeck-node::local_user')
  end

  it 'includes rundeck-node::auth_key recipe when auth::key is true' do
    expect(linux_chef_run(auth: { key: true })).to include_recipe('rundeck-node::auth_key')
    expect(windows_chef_run_with_cert(true, auth: { key: true })).to include_recipe('rundeck-node::auth_key')
  end
end
