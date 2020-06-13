
# create the role
resource "aws_iam_role" "ssm_managed_instance_role" {
  name = "ssm_managed_instance_role"
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

# create policy to grant access to ssm buckets
resource "aws_iam_policy" "ssm_s3_bucket_access_policy" {
  name = "ssm_s3_bucket_access_policy"
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

data "aws_iam_policy_document" "saltstack_codecommit_git_clone" {

  statement {
    effect    = "Allow"
    actions   = ["codecommit:BatchGetRepositories"]
    resources = ["arn:aws:codecommit:${var.aws_region}:${var.aws_account_id}:saltstack"]
  }
}


resource "aws_iam_policy" "saltstack_codecommit_git_clone" {
  name   = "permit_clone_from_saltstack_codecommit_repo"
  policy = data.aws_iam_policy_document.saltstack_codecommit_git_clone.json
}

data "aws_iam_policy_document" "manage_ec2_tags" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateTags", "ec2:DescribeInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "manage_ec2_tags" {
  name   = "permit_ec2_to_manage_tags"
  policy = data.aws_iam_policy_document.manage_ec2_tags.json
}

# Attach the bucket access policy to the role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_attach" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = aws_iam_policy.ssm_s3_bucket_access_policy.arn
}

# Attach the AWS managed AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore_attach" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach the AWS managed CloudWatchAgentServerPolicy policy to the role
resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy_attach" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# attach the role to the profile. The profile is what will finally be attached to the Ec2 instance
resource "aws_iam_instance_profile" "ssm_managed_instance_profile" {
  name = "ssm_managed_instance_profile"
  role = aws_iam_role.ssm_managed_instance_role.name
}


resource "aws_iam_role_policy_attachment" "saltstack_codecommit_git_clone_attach" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = aws_iam_policy.saltstack_codecommit_git_clone.arn
}

resource "aws_iam_role_policy_attachment" "manage_ec2_tags_attach" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = aws_iam_policy.manage_ec2_tags.arn
}


# Attach the AWS managed CloudWatchAgentServerPolicy policy to the role
resource "aws_iam_role_policy_attachment" "AWSCodeCommitReadOnly" {
  role       = aws_iam_role.ssm_managed_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"
}