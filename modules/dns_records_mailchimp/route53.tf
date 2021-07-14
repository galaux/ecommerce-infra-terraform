resource "aws_route53_record" "dkim_mailchimp" {
  for_each = var.mailchimp_dkim_tokens

  zone_id = var.zone_base.dns_zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = "600"
  records = [each.value]
}
