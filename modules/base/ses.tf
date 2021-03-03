# This resource creates the example.xyz entry in SES "domain entities"
# which automatically starts the AWS verification process. During this process
# period (which took less than 5' in effect but can take quite some time in
# theory), SES field "Verification" is set to "pending verification" then when
# done to "verified".
resource "aws_ses_domain_identity" "main" {
  domain = var.parent_domain
}


# SES verification record (`_amazonses`)
resource "aws_route53_record" "ses_verification_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "_amazonses.${var.parent_domain}"
  type    = "TXT"
  ttl     = "1800"
  records = [aws_ses_domain_identity.main.verification_token]
}

# # As the name suggest, this must start the domain verification process though
# # this process seems to be automatically started when the
# # `aws_ses_domain_identity` is created. Let's have it anyway.
# resource "aws_ses_domain_identity_verification" "ses_verification" {
#   domain     = aws_ses_domain_identity.main.id
#   depends_on = [aws_route53_record.ses_verification_record]
# }


# DKIM records
# This resource generates the three DKIM values (though it doesn't create the
# corresponding DNS records) and sets the SES field "DKIM Status" to "pending
# verification". It seems we then need to create the three DNS fields for the
# verification process to continue.
resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

