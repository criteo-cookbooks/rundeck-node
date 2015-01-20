#
# Cookbook:   rundeck-node
# Attributes: node
#

# RunDeck node access configuration depending on OS
case node['os']
when 'linux'
  # User type on node
  default['rundeck_node']['account'] = 'local'
  default['rundeck_node']['user']    = 'rundeck'
  default['rundeck_node']['group']   = 'rundeck'
  default['rundeck_node']['home']    = '/home/rundeck'
  # Authentication type
  default['rundeck_node']['auth']    = 'key'
  default['rundeck_node']['key']     = 'PublicSSHKey'
when 'windows'
  # User type on node
  default['rundeck_node']['account'] = 'domain'
  # Authentication type
  default['rundeck_node']['auth']    = 'kerberos'
end
