# IMPORTANT: As [officially explained][0]:
# > When an IAM role is attached to the instance, the AWS CLI automatically and
# > securely retrieves the credentials from the instance metadata.
#
# This means that attaching this role to the EC2 instance effectively enables
# applications (such as CLI `aws`) work by using the credentials provided in
# the metadata.
#
# [0]: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-metadata.html


resource "aws_iam_role" "std_ec2" {
  name = "shop-ec2"
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

resource "aws_iam_policy" "std_s3_policy" {
  name        = "shop-s3-bucket"
  description = "Allow access to the example backup S3 bucket"
  # TODO tame down S3 privs to the strict minimum
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "s3:*",
        Resource : [
          aws_s3_bucket.std_backup_test.arn,
          "${aws_s3_bucket.std_backup_test.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_s3_policy_ec2_std" {
  name       = "attach-s3-policy-ec2-shop"
  roles      = [aws_iam_role.std_ec2.name]
  policy_arn = aws_iam_policy.std_s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.std_ec2.name
}
