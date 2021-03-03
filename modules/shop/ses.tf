# SPF record
resource "aws_route53_record" "std_tk_spf" {
  zone_id = var.dns_zone_id
  name    = "example.tk"
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 ip4:${local.ec2_std_ip} ~all"]
}

# DMARC record
resource "aws_route53_record" "std_tk_dmarc" {
  zone_id = var.dns_zone_id
  name    = "_dmarc.example.tk"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1; p=none; rua=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; ruf=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; fo=1;"]
}

# MX record
resource "aws_route53_record" "std_tk_mx" {
  zone_id = var.dns_zone_id
  name    = "example.tk"
  type    = "MX"
  ttl     = "600"
  records = ["1 example.tk."]
}

# DKIM records
resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = var.dns_zone_id
  name    = "${element(var.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(var.dkim_tokens, count.index)}.dkim.amazonses.com"]
}


# SMTP user
resource "aws_iam_user" "ses_smtp" {
  name = "ses-smtp"
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
