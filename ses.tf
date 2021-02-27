# This resource creates the example.tk entry in SES "domain entities"
# which starts the automatic AWS verification process. During this verification
# period which can take quite some time, SES field "Verification" is set to
# "pending verification" then when done to "verified".
# Also see:
# - `ses_domain_identity_verification` which as far as I understand doesn't
#   create anything. It rather seems to be a way to get from AWS whether or not
#   the identity verification is done and positive so that we can use the info
#   on Terraform.
# - `aws_ses_domain_dkim.std_tk` which adds the "DKIM status" to `verified`
#
# [0]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification
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

# SPF
resource "aws_route53_record" "std_tk_spf" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "example.tk"
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 ip4:${aws_instance.std_ec2.public_ip} ~all"]
}

# # DMARC
# resource "aws_route53_record" "std_tk_dmarc" {
#   zone_id = aws_route53_zone.std_tk.zone_id
#   name    = "_dmarc.example.tk"
#   type    = "TXT"
#   ttl     = "600"
#   records = ["v=DMARC1; p=none; rua=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; ruf=mailto:dmarcreports-shop@alaux.net,mailto:owner@example.com; fo=1;"]
# }


# MX
resource "aws_route53_record" "std_tk_mx" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "example.tk"
  type    = "MX"
  ttl     = "600"
  records = ["1 example.tk."]
}

# DKIM
# This resource set the SES field "DKIM Status" to "pending verification" then
# to "verified" once the automatic AWS verification process is successful.
# FIXME move this resource out of this folder and set `prevent_destroy=true`
resource "aws_ses_domain_dkim" "std_tk" {
  domain = aws_ses_domain_identity.std_tk.domain
}

# resource "aws_route53_record" "example_amazonses_dkim_record" {
#   count   = 3
#   zone_id = aws_route53_zone.std_tk.zone_id
#   name    = "${element(aws_ses_domain_dkim.std_tk.dkim_tokens, count.index)}._domainkey"
#   type    = "CNAME"
#   ttl     = "600"
#   records = ["${element(aws_ses_domain_dkim.std_tk.dkim_tokens, count.index)}.dkim.amazonses.com"]
# }
