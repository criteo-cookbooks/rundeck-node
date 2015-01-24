require 'spec_helper'

describe 'rundeck-node::auth_key' do

  let(:linux_chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  describe 'on windows' do
    let(:windows_chef_run) do
      allow(Chef::Config).to receive(:[]).and_call_original
      allow(Chef::Config).to receive(:[]).with('file_cache_path').and_return('')
      expect(OpenSSL::X509::Certificate).to receive(:new).and_return double('new certificate', to_der: 'DER_CERT')
      expect(Digest::SHA1).to receive(:hexdigest).with('DER_CERT').and_return('0123456789ABCDEF')
      stub_command('Test-Path cert:LocalMachine/Root/0123456789ABCDEF').and_return(false)
      ChefSpec::SoloRunner.new(WINDOWS_OHAI) do |node|
        node.set['rundeck_node']['user_password_file'] = 'dummy_file'
        node.set['rundeck_node']['auth_public_key'] = 'PUBLIC_KEY_CONTENT'
      end.converge described_recipe
    end

    it 'stores the public key in the cache folder' do
      expect(windows_chef_run).to create_file('/rundeck.pem').with(content: 'PUBLIC_KEY_CONTENT')
    end

    it 'imports the public key in the LocalMachine\Root store' do
      expect(windows_chef_run).to run_execute('Import public key into LocalMachine\Root')
    end

    it 'configures winrm certmapping' do
      expect(windows_chef_run).to configure_winrm_config_service_certmapping('rundeck')
          .with({
            username: 'rundeck',
            password: nil,
            issuer: '0123456789ABCDEF',
            uri: '*',
            subject: '*',
          })
    end
  end

  describe 'on linux' do
    it 'creates .ssh directory' do
      expect(linux_chef_run).to create_directory('/home/rundeck/.ssh')
    end

    it 'configures authorized keys' do
      expect(linux_chef_run).to create_file('/home/rundeck/.ssh/authorized_keys')
    end
  end
end
