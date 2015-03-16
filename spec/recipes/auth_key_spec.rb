require 'spec_helper'

describe 'rundeck-node::auth_key' do

  describe 'on windows' do

    it 'stores the public key in the cache folder' do
      expect(windows_chef_run_with_cert(false, user_password: 'test')).to create_file('/rundeck.pem').with(content: 'PUBLIC_KEY_CONTENT')
    end

    it 'imports the public key in the LocalMachine\Root store' do
      expect(windows_chef_run_with_cert(false, user_password: 'test')).to run_execute('Import public key into LocalMachine\Root')
    end

    it 'configures winrm certmapping' do
      expect(windows_chef_run_with_cert(false, user_password: 'test')).to configure_winrm_config_service_certmapping('rundeck')
          .with({
            username: 'rundeck',
            password: 'test',
            issuer: '0123456789ABCDEF',
            uri: '*',
            subject: '*',
          })
    end
  end

  describe 'on linux' do
    let(:linux_chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it 'creates .ssh directory' do
      expect(linux_chef_run).to create_directory('/home/rundeck/.ssh')
    end

    it 'configures authorized keys' do
      expect(linux_chef_run).to create_file('/home/rundeck/.ssh/authorized_keys')
    end
  end
end
