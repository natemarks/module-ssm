# Create the roles, etc
module "ssm_account_access" {

  source = "git::git@github.com:natemarks/module-ssm.git//modules/ssm_ec2_profile?ref=v0.0.1"

  aws_region = var.aws_region
  aws_account_id = var.aws_account_id
}




#  Locate the instance profile by name
data "aws_iam_instance_profile" "ssm_managed_instance_profile" {
  name = "ssm_managed_instance_profile"
}

# use a generic amazon linux ami
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "biometric-aware" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = "SOME_VALID-SUBNET_ID"

  # apply the instance profile created by this module
  iam_instance_profile = data.aws_iam_instance_profile.ssm_managed_instance_profile.name

  tags = {
    terraform = "true"
  }
}