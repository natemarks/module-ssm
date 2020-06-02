data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${data.aws_vpc.selected.id}"
  service_name = "ssm.${var.aws_region}.amazonaws.com"

  tags = var.tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${data.aws_vpc.selected.id}"
  service_name = "ssmmessages.${var.aws_region}.amazonaws.com"

  tags = var.tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${data.aws_vpc.selected.id}"
  service_name = "ec2messages.${var.aws_region}.amazonaws.com"

  tags = var.tags
}
