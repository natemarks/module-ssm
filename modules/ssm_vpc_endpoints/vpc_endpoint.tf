data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = data.aws_vpc.selected.id
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}
