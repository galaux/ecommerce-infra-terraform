resource "aws_route53_record" "parent_domain" {
  zone_id = var.dns_zone_id
  name    = "example.tk"
  type    = "A"
  ttl     = "300"
  records = [local.instance_ip]
}

resource "aws_route53_record" "sub_domain" {
  for_each = toset(var.sub_domains)
  zone_id  = var.dns_zone_id
  name     = "${each.key}.example.tk"
  type     = "A"
  ttl      = "300"
  records  = [local.instance_ip]
}
