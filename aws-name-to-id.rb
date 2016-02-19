# Used to find group and subnet ids from their names

begin
  require 'aws-sdk'
rescue LoadError
  raise 'Missing "aws-sdk" gem. Install it or use ChefDK.'
end

group_name =  ENV['AWS_SECURITY_GROUP'] || 'criteo-sre-core-testing-oss-vpc-security-group'
subnet_name = ENV['AWS_SUBNET'] || 'criteo-sre-core-testing-oss-vpc-subnet-1'
@region =     ENV['AWS_REGION'] || 'us-west-2'
ec2 =         Aws::EC2::Client.new(region: @region)

group = ec2.describe_security_groups(
  filters: [
    {
      name:   'group-name',
      values: [group_name]
    }
  ]
)[0][0]
raise "The group named '#{group_name}' does not exist!!!" unless group
@group_id = group.group_id

subnet = ec2.describe_subnets(
  filters: [
    {
      name:   'tag:Name',
      values: [subnet_name]
    }
  ]
)[0][0]
raise "The group named '#{subnet_name}' does not exist!!!" unless subnet
@subnet_id = subnet.subnet_id

@availability_zone = ec2.describe_subnets(
  subnet_ids: [@subnet_id]
)[0][0].availability_zone
