#
# Author:: Robert Veznaver (<r.veznaver@criteo.com>)
# Cookbook Name:: rundeck-node
# Attribute:: default
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

# User type on node (could be local or domain)
default['rundeck_node']['account']               = 'local'
default['rundeck_node']['user']                  = 'rundeck'
default['rundeck_node']['user_password_file']    = nil
default['rundeck_node']['user_password']         = nil

default['rundeck_node']['keepass_version']       = nil

# Authentication types
default['rundeck_node']['auth']['key']           = true
# Not handled yet
# default['rundeck_node']['auth']['password']      = false
# default['rundeck_node']['auth']['kerberos']      = false

# Authentication public key
default['rundeck_node']['auth_public_key']       = nil

# RunDeck node access configuration depending on OS
case node['os']
when 'linux'
  default['rundeck_node']['group']               = 'rundeck'
  default['rundeck_node']['home']                = '/home/rundeck'
when 'windows'
  default['rundeck_node']['group']               = 'Administrators'
  default['rundeck_node']['home']                = 'C:\ProgramData\rundeck'
  default['rundeck_node']['user_password_file']  = ::File.join(::Chef::Config['file_cache_path'], 'rundeck.pwd')
end
