resource "aws_route53_record" "std_tk" {
  zone_id = var.dns_zone_id
  name    = "example.tk"
  type    = "A"
  ttl     = "300"
  records = [local.ec2_std_ip]
}

resource "aws_route53_record" "std_tk_" {
  for_each = toset(var.sub_domains)
  zone_id  = var.dns_zone_id
  name     = "${each.key}.example.tk"
  type     = "A"
  ttl      = "300"
  records  = [local.ec2_std_ip]
}
