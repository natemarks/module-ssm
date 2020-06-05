data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "ssm_vpc_endpoint" {
  vpc_id = var.vpc_id

  # Allow inbound HTTPS for AWS API calls
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssmmessages_vpc_endpoint" {
  vpc_id = var.vpc_id

  # Allow inbound HTTPS for AWS API calls
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "ec2messages_vpc_endpoint" {
  vpc_id = var.vpc_id

  # Allow inbound HTTPS for AWS API calls
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc_endpoint_service" "ssm" {
  service = "ssm"
}

data "aws_vpc_endpoint_service" "ssmmessages" {
  service = "ssmmessages"
}

data "aws_vpc_endpoint_service" "ec2messages" {
  service = "ec2messages"
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = data.aws_vpc.selected.id
  security_group_ids = [aws_security_group.ssm_vpc_endpoint.id]
  service_name = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = data.aws_vpc.selected.id
  security_group_ids = [aws_security_group.ssmmessages_vpc_endpoint.id]
  service_name = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = data.aws_vpc.selected.id
  security_group_ids = [aws_security_group.ec2messages_vpc_endpoint.id]
  service_name = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"
  tags = var.tags
}
