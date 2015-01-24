require 'spec_helper'

describe 'rundeck-node::default' do

  def windows_chef_run(attributes = {})
    expect(OpenSSL::X509::Certificate).to receive(:new).and_return double('new certificate', to_der: 'DER_CERT')
    expect(Digest::SHA1).to receive(:hexdigest).with('DER_CERT').and_return '0123456789ABCDEF'
    stub_command('Test-Path cert:LocalMachine/Root/0123456789ABCDEF').and_return(true)
    ChefSpec::SoloRunner.new(WINDOWS_OHAI) do |node|
      node.set['rundeck_node'] = attributes.merge(user_password_file: 'dummy_file', auth_public_key: 'PUBLIC_KEY_CONTENT')
    end.converge described_recipe
  end
  def linux_chef_run(attributes = {})
    ChefSpec::SoloRunner.new do |node|
      node.set['rundeck_node'] = attributes
    end.converge described_recipe
  end

  it 'includes rundeck-node::local_user recipe when account is local' do
    expect(windows_chef_run(account: 'local')).to include_recipe('rundeck-node::local_user')
    expect(linux_chef_run(account: 'local')).to include_recipe('rundeck-node::local_user')
  end

  it 'includes rundeck-node::auth_key recipe when auth::key is true' do
    expect(linux_chef_run(auth: { key: true })).to include_recipe('rundeck-node::auth_key')
    expect(windows_chef_run(auth: { key: true })).to include_recipe('rundeck-node::auth_key')
  end
end
