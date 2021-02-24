resource "aws_iam_role" "tf_ec2_role" {

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::prestashop-data",
          "arn:aws:s3:::prestashop-data/*"
        ]
      },

      # Required for test instances to update their corresponding DNS entries
      # when manually running Ansible. Will ultimately be done by Terraform.
      # TODO remove this when performed by Terraform
      {
        Effect = "Allow"
        Action = [
          "cloudfront:ListDistributions",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricStatistics",
          "ec2:DescribeRegions",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "elasticbeanstalk:DescribeEnvironments",
          "elasticloadbalancing:DescribeLoadBalancers",
          "route53:*",
          "route53domains:*",
          "s3:GetBucketLocation",
          "s3:GetBucketWebsite",
          "s3:ListBucket",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics"
        ],
        Resource = "*"
      },
      {
        Effect : "Allow",
        Action : "apigateway:GET",
        Resource : "arn:aws:apigateway:*::/domainnames"
      }

    ]
  })

}
