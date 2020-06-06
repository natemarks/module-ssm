These modules are intended to work wiht VPCs created by the gruntworks vpc modules in https://github.com/gruntwork-io/module-vpc



modules/ssm_account_access:

Create tee policies that need to be attachd to E2 instances so they can be managed by SSM (https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-profile.html):\

 - access_ssm_bucket_policy:  created by this module
 -  AmazonSSMManagedInstanceCore: pre-built AWS policy 
 - CloudWatchAgentServerPolicy
 
 
modules/ssm_vpc_endpoints:
CReate the VPC endpoints for the SSM-requred services. This allows instances on the privatye subnets toaccess SSM withouth internet access and keeps SSM traffic on the VPC (https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html):

NOTE: DO  NOT create com.amazonaws.region.ec2. We create it with https://github.com/gruntwork-io/module-vpc/tree/master/modules/vpc-app.

 - com.amazonaws.region.ssm
 - com.amazonaws.region.ec2messages
 - com.amazonaws.region.ssmmessages
 - The security group attached to the com.amazonaws.region.ssm endpoint needs tpo permit tcp/443 from any VPC host
 
 