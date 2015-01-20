#
# Cookbook: rundeck-node
# Recipe:   default
#

# Select recipe for node based on Ohai OS
case node['os']
when 'linux'
  include_recipe 'rundeck-node::linux'
when 'windows'
  include_recipe 'rundeck-node::windows'
else
  fail 'Unsupported OS'
end
