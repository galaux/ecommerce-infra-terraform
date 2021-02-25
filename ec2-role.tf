# resource "aws_iam_role" "tf_ec2_role" {
#   name = "tf_ec2_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [

#       {
#         Effect = "Allow"
#         Action = "s3:*"
#         Resource = [
#           "arn:aws:s3:::prestashop-data",
#           "arn:aws:s3:::prestashop-data/*"
#         ]
#       },

#       # # Required for test instances to update their corresponding DNS entries
#       # # when manually running Ansible. Will ultimately be done by Terraform.
#       # # TODO remove this when performed by Terraform
#       # {
#       #   Effect = "Allow"
#       #   Action = [
#       #     "cloudfront:ListDistributions",
#       #     "cloudwatch:DescribeAlarms",
#       #     "cloudwatch:GetMetricStatistics",
#       #     "ec2:DescribeRegions",
#       #     "ec2:DescribeVpcEndpoints",
#       #     "ec2:DescribeVpcs",
#       #     "elasticbeanstalk:DescribeEnvironments",
#       #     "elasticloadbalancing:DescribeLoadBalancers",
#       #     "route53:*",
#       #     "route53domains:*",
#       #     "s3:GetBucketLocation",
#       #     "s3:GetBucketWebsite",
#       #     "s3:ListBucket",
#       #     "sns:ListSubscriptionsByTopic",
#       #     "sns:ListTopics"
#       #   ],
#       #   Resource = "*"
#       # },
#       # {
#       #   Effect : "Allow",
#       #   Action : "apigateway:GET",
#       #   Resource : "arn:aws:apigateway:*::/domainnames"
#       # }

#     ]
#   })

# }

# resource "aws_iam_role" "tf_ec2_role" {
#   name                = "tf_ec2_role"
#   assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)
#   managed_policy_arns = [aws_iam_policy.policy_one.arn, aws_iam_policy.policy_two.arn]
# }

# resource "aws_iam_policy" "policy_two" {
#   name = "policy-381966"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = ["s3:ListAllMyBuckets", "s3:ListBucket", "s3:HeadBucket"]
#         Effect   = "Allow"
#         Resource = aws_s3_bucket.std_backup_test
#       },
#     ]
#   })
# }
