resource "aws_iam_user" "ses_smtp" {
  name = "ses-smtp-${var.name}"
}

resource "aws_iam_user_policy" "ses_smtp" {
  name = "AmazonSesSendingAccess"
  user = aws_iam_user.ses_smtp.name
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "ses:SendRawEmail",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
}

# FIXME For production (example.com), we've had to ask AWS staff to get
# us out of the SES "sandbox". Do we need to do this or could we "hard code"
# our 3 or 4 email addresses for "test" instances?
