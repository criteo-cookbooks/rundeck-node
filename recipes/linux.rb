#
# Cookbook: rundeck-node
# Recipe:   linux
#

# Local account creation
group node['rundeck_node']['group'] do
  system true
  only_if { node['rundeck_node']['account'] == 'local' }
end

user node['rundeck_node']['user'] do
  comment   'Rundeck User'
  home      node['rundeck_node']['home']
  gid       node['rundeck_node']['group']
  shell     '/bin/bash'
  system    true
  only_if   { node['rundeck_node']['account'] == 'local' }
end

directory node['rundeck_node']['home'] do
  owner     node['rundeck_node']['user']
  group     node['rundeck_node']['group']
  mode      '00700'
  recursive true
  only_if   { node['rundeck_node']['account'] == 'local' }
end

# SSH public key placement
directory "#{node['rundeck_node']['home']}/.ssh" do
  owner     node['rundeck_node']['user']
  group     node['rundeck_node']['group']
  mode      '00700'
  recursive true
  only_if   { node['rundeck_node']['auth'] == 'key' }
end

file "#{node['rundeck_node']['home']}/.ssh/authorized_keys" do
  owner     node['rundeck_node']['user']
  group     node['rundeck_node']['group']
  content   node['rundeck_node']['key']
  mode      '00600'
  backup    false
  only_if   { node['rundeck_node']['auth'] == 'key' }
end

# sudo access
sudo 'rundeck-node' do
  user      node['rundeck_node']['user']
  nopasswd  true
end
