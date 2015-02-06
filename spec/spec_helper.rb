require 'chefspec'
require 'chefspec/berkshelf'

WINDOWS_OHAI = { os: 'windows', platform: 'windows', version: '2008R2' }

RSpec.configure do |config|
  config.platform = 'centos'
  config.version  = '6.5'
end

def windows_file_rights_hack
  # File permissions on Windows depend on RUBY_PLATFORM and we don't want to
  # change it in Rspec so we include the appropriate modules.
  # See:
  # https://github.com/chef/chef/blob/master/lib/chef/mixin/securable.rb#L182

  Chef::Resource::File.send(:include, Chef::Mixin::Securable::WindowsSecurableAttributes)
  Chef::Resource::File.extend Chef::Mixin::Securable::WindowsMacros
  Chef::Resource::File.rights_attribute :rights
  Chef::Resource::File.rights_attribute :deny_rights
end

def windows_chef_run_with_cert(cert_exist, attributes = {})
  # Mock file_cache_path
  allow(Chef::Config).to receive(:[]).and_call_original
  allow(Chef::Config).to receive(:[]).with('file_cache_path').and_return('')

  # Mock a X509 certificate
  expect(OpenSSL::X509::Certificate).to receive(:new).and_return double('new certificate', to_der: 'DER_CERT')
  expect(Digest::SHA1).to receive(:hexdigest).with('DER_CERT').and_return('0123456789ABCDEF')

  # This is used in a guard to import certificate or not.
  stub_command('Test-Path cert:LocalMachine/Root/0123456789ABCDEF').and_return(cert_exist)

  windows_file_rights_hack

  ChefSpec::SoloRunner.new(WINDOWS_OHAI) do |node|
    node.set['rundeck_node'] = attributes.merge(
      user_password_file: 'dummy_file',
      auth_public_key:    'PUBLIC_KEY_CONTENT'
    )
  end.converge described_recipe
end
