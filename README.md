These modules are intended to work wiht VPCs created by the gruntworks vpc modules in https://github.com/gruntwork-io/module-vpc with the following vpc endpoints enabled:
 - ssm
 - ssmmessages
 - ec2
 - ec2messages

modules/ssm_ec2_profile:

Create and maname an EC2 instance profile that allows an ec2 instance to be managed by SSM(https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-instance-profile.html):

 - ssm_managed_instance_policy (created by this module)
 - AmazonSSMManagedInstanceCore (managed by AWS)
 - CloudWatchAgentServerPolicy (managed by AWS)
