resource "aws_route53_record" "parent_domain" {
  zone_id = var.dns.dns_zone_id
  name    = var.dns.parent_domain
  type    = "A"
  ttl     = "300"
  records = [local.target_ip]
}

resource "aws_route53_record" "sub_domain" {
  for_each = toset(var.sub_domains)
  zone_id  = var.dns.dns_zone_id
  name     = "${each.key}.${var.dns.parent_domain}"
  type     = "A"
  ttl      = "300"
  records  = [local.target_ip]
}


resource "aws_route53_record" "spf" {
  zone_id = var.dns.dns_zone_id
  name    = var.dns.parent_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 ip4:${local.target_ip} ~all"]
}

resource "aws_route53_record" "dmarc" {
  zone_id = var.dns.dns_zone_id
  name    = "_dmarc.${var.dns.parent_domain}"
  type    = "TXT"
  ttl     = "600"
  # FIXME factorize this
  records = ["v=DMARC1; p=none; rua=mailto:dmarcreports+${var.dns.parent_domain}@alaux.net,mailto:owner+${var.dns.parent_domain}@gmail.com; ruf=mailto:dmarcreports+${var.dns.parent_domain}@alaux.net,mailto:owner+${var.dns.parent_domain}@gmail.com; fo=1;"]
}

resource "aws_route53_record" "mx" {
  zone_id = var.dns.dns_zone_id
  name    = var.dns.parent_domain
  type    = "MX"
  ttl     = "600"
  records = ["1 ${var.dns.parent_domain}."]
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = var.dns.dns_zone_id
  name    = "${element(var.dns.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(var.dns.dkim_tokens, count.index)}.dkim.amazonses.com"]
}


# We refrain from using an EIP for test instances as these must be paid for if
# not assigned to a running instance. For test instances, we thus have the DNS
# records point at the EC2 instance public IP directly.
resource "aws_eip" "instance" {
  count    = var.use_eip ? 1 : 0
  instance = var.instance.id
  vpc      = true
}
