# IMPORTANT: As [officially explained][0]:
# > When an IAM role is attached to the instance, the AWS CLI automatically and
# > securely retrieves the credentials from the instance metadata.
#
# This means that attaching this role to the EC2 instance effectively enables
# applications (such as CLI `aws`) work by using the credentials provided in
# the metadata.
#
# [0]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-metadata.html


resource "aws_iam_role" "ec2_assume" {
  name = "${var.name}-ec2-assume"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
}


resource "aws_iam_policy" "s3_bucket_access" {
  name        = "${var.name}-s3-bucket-access"
  description = "Allow access to the backup S3 bucket"
  # TODO tame down S3 privs to the strict minimum
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "s3:*",
        Resource : [
          var.backup_bucket_arn,
          "${var.backup_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy_ec2" {
  role       = aws_iam_role.ec2_assume.name
  policy_arn = aws_iam_policy.s3_bucket_access.arn
}


resource "aws_iam_policy" "update_dns" {
  name        = "${var.name}-update-dns"
  description = "Allow updating the DNS records"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "route53:ChangeResourceRecordSets"
        ],
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dns_policy_ec2" {
  role       = aws_iam_role.ec2_assume.name
  policy_arn = aws_iam_policy.update_dns.arn
}


# Watch-out: see remark where we provision the EC2 instance about EC2 profiles
# only being associated with the instance at instance creation time.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.ec2_assume.name
}
