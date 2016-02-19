# Used to find group and subnet ids from their names

require 'aws-sdk'

group_name =  ENV['AWS_SECURITY_GROUP'] || 'criteo-sre-core-testing-oss-vpc-security-group'
subnet_name = ENV['AWS_SUBNET'] || 'criteo-sre-core-testing-oss-vpc-subnet-1'
region =      ENV['AWS_REGION'] || 'us-west-2'
ec2 =         Aws::EC2::Client.new(region: region)

@group_id = ec2.describe_security_groups(
  filters: [
    {
      name: 	'group-name',
      values: [group_name]
    }
  ]
)[0][0].group_id

@subnet_id = ec2.describe_subnets(
  filters: [
    {
      name:   'tag:Name',
      values: [subnet_name]
    }
  ]
)[0][0].subnet_id
