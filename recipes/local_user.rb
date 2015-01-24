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
  if ::File.exist?(node['rundeck_node']['user_password_file'])
    user_pwd = ::File.read(node['rundeck_node']['user_password_file'])
  else
    # include OpenSSL function secure_password
    self.class.send(:include, Opscode::OpenSSL::Password)
    user_pwd = secure_password
  end

  file node['rundeck_node']['user_password_file'] do
    content        user_pwd
    backup         false
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
