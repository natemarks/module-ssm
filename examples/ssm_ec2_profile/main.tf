
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