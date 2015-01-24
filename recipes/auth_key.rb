#
# Author:: Robert Veznaver (<r.veznaver@criteo.com>)
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: rundeck-node
# Resource:: auth_key
#
# Copyright:: Copyright (c) 2015 Criteo.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['os']
when 'linux'
  # SSH public key placement
  directory "#{node['rundeck_node']['home']}/.ssh" do
    owner     node['rundeck_node']['user']
    group     node['rundeck_node']['group']
    mode      '00700'
    recursive true
  end

  file "#{node['rundeck_node']['home']}/.ssh/authorized_keys" do
    owner     node['rundeck_node']['user']
    group     node['rundeck_node']['group']
    content   node['rundeck_node']['auth_public_key']
    mode      '00600'
    backup    false
  end
when 'windows'

  include_recipe 'rundeck-node::local_user'

  require 'openssl'
  require 'digest/sha1'

  public_key = node['rundeck_node']['auth_public_key']
  public_key_file = ::File.join(Chef::Config['file_cache_path'], 'rundeck.pem')
  thumbprint = Digest::SHA1.hexdigest(OpenSSL::X509::Certificate.new(public_key).to_der).upcase

  file public_key_file do
    content public_key
  end

  execute 'Import public key into LocalMachine\Root' do # ~FC009
    command           "certutil -addstore Root #{public_key_file}"
    guard_interpreter :powershell_script
    not_if            "Test-Path cert:LocalMachine/Root/#{thumbprint}"
  end

  file_resource_name = "file[#{node['rundeck_node']['user_password_file']}]"
  pwd_file_content = resources(file_resource_name).content if resources.include? file_resource_name
  winrm_config_service_certmapping node['rundeck_node']['user'] do
    username      node['rundeck_node']['user']
    password      node['rundeck_node']['user_password'] || pwd_file_content
    issuer        thumbprint
    subject       '*'
    uri           '*'
  end
else
  fail 'Unsupported OS'
end
