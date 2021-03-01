# This resource creates the example.tk entry in SES "domain entities"
# which automatically starts the AWS verification process. During this process
# period (which took less than 5' in effect but can take quite some time in
# theory), SES field "Verification" is set to "pending verification" then when
# done to "verified".
#
# Because of this AWS identity verification mechanism, we might want to have
# `aws_ses_domain_identity.std_tk` in a separate directory
# along with _long lived_ resources (EC2 key pair, Route53 delegation set, …).
# FIXME move this resource out of this folder and set `prevent_destroy=true`
#
resource "aws_ses_domain_identity" "std_tk" {
  domain = "example.tk"
}

# SES verification record (`_amazonses`)
resource "aws_route53_record" "std_tk_ses_verification_record" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "_amazonses.example.tk"
  type    = "TXT"
  ttl     = "1800"
  records = [aws_ses_domain_identity.std_tk.verification_token]
}

# As the name suggest, this must start the domain verification process though
# this process seems to be automatically started when the
# `aws_ses_domain_identity` is created. Let's have it anyway.
resource "aws_ses_domain_identity_verification" "std_tk_ses_verification" {
  domain     = aws_ses_domain_identity.std_tk.id
  depends_on = [aws_route53_record.std_tk_ses_verification_record]
}


# SPF record
resource "aws_route53_record" "std_tk_spf" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "example.tk"
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 ip4:${local.ec2_std_ip} ~all"]
}


# DMARC record
resource "aws_route53_record" "std_tk_dmarc" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "_dmarc.example.tk"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1; p=none; rua=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; ruf=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; fo=1;"]
}


# MX record
resource "aws_route53_record" "std_tk_mx" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "example.tk"
  type    = "MX"
  ttl     = "600"
  records = ["1 example.tk."]
}


# DKIM records
# This resource generates the three DKIM values (though it doesn't create the
# corresponding DNS records) and sets the SES field "DKIM Status" to "pending
# verification". It seems we then need to create the three DNS fields for the
# verification process to continue.
# FIXME move this resource out of this folder and set `prevent_destroy=true`
resource "aws_ses_domain_dkim" "std_tk" {
  domain = aws_ses_domain_identity.std_tk.domain
}

resource "aws_route53_record" "example_amazonses_dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "${element(aws_ses_domain_dkim.std_tk.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.std_tk.dkim_tokens, count.index)}.dkim.amazonses.com"]
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
