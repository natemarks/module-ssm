resource "aws_iam_role" "access_ssm_bucket_role" {
  name = "access_ssm_bucket_role"
  description = "Role to permit EC2 instance access to SSM s3 bucket in a region"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF

  tags = var.tags
}

resource "aws_iam_policy" "access_ssm_bucket_policy" {
  name = "access_ssm_bucket_policy"
  description = "Policy to permit EC2 instance access to SSM s3 bucket in a region"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::aws-ssm-${var.aws_region}/*",
                "arn:aws:s3:::aws-windows-downloads-${var.aws_region}/*",
                "arn:aws:s3:::amazon-ssm-${var.aws_region}/*",
                "arn:aws:s3:::amazon-ssm-packages-${var.aws_region}/*",
                "arn:aws:s3:::${var.aws_region}-birdwatcher-prod/*",
                "arn:aws:s3:::patch-baseline-snapshot-${var.aws_region}/*"
            ]
        }
    ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "access_ssm_bucket_attach" {
  role       = aws_iam_role.access_ssm_bucket_role.name
  policy_arn = aws_iam_policy.access_ssm_bucket_policy.arn
}
