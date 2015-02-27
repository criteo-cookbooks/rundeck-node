#
# Author:: Robert Veznaver (<r.veznaver@criteo.com>)
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
# Cookbook Name:: rundeck-node
# Resource:: local_user
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

user_pwd = node['rundeck_node']['user_password']
if node['rundeck_node']['user_password_file']

  chef_gem 'keepass-password-generator' do
    version node['rundeck_node']['keepass_version']
  end

  if ::File.exist?(node['rundeck_node']['user_password_file'])
    user_pwd = ::File.read(node['rundeck_node']['user_password_file'])
  else
    # Generate a password meeting microsoft password complexity requirements
    # https://technet.microsoft.com/en-us/library/cc786468(v=ws.10).aspx
    # in short: at least 1 uppercase, 1 lowercase, 1 digit, 1 special char
    require 'keepass/password'
    user_pwd = KeePass::Password.generate("uldsS{26}")
  end

  # store the password in run_state for future use
  node.run_state['rundeck_user_password'] = user_pwd

  file node['rundeck_node']['user_password_file'] do
    content        user_pwd
    backup         false
    case node['os']
    when 'linux'
      owner        root
      mode         '0600'
    when 'windows'
      inherits     false
      rights       :full_control, 'SYSTEM'
    end
  end
end

user node['rundeck_node']['user'] do
  comment          'Rundeck User'
  manage_home      true
  home             node['rundeck_node']['home']
  unless platform? 'windows'
    shell          '/bin/bash'
    system         true
  end
  password         user_pwd unless user_pwd.nil?
end

group node['rundeck_node']['group'] do
  system           true
  members          node['rundeck_node']['user']
  append           true
end

# sudo access
sudo 'rundeck-node' do
  user           node['rundeck_node']['user']
  nopasswd       user_pwd.nil?
  only_if        { node['os'] == 'linux' }
end
