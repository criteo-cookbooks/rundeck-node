require 'chefspec'
require 'chefspec/berkshelf'

WINDOWS_OHAI = { os: 'windows', platform: 'windows', version: '2008R2' }

RSpec.configure do |config|
  config.platform = 'centos'
  config.version  = '6.5'
end
