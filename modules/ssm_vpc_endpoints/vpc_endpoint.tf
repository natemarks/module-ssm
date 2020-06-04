data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"

  tags = var.tags
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"

  tags = var.tags
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"

  tags = var.tags
}
