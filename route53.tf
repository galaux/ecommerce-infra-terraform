resource "aws_route53_zone" "std_tk" {
  name = "example.tk"
}

resource "aws_route53_record" "std_tk" {
  zone_id = aws_route53_zone.std_tk.zone_id
  name    = "example.tk"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.std_ec2.public_ip]
}

resource "aws_route53_record" "std_tk_" {
  for_each = toset(var.sub_domains)
  zone_id  = aws_route53_zone.std_tk.zone_id
  name     = "${each.key}.example.tk"
  type     = "A"
  ttl      = "300"
  records  = [aws_eip.std_ec2.public_ip]
}
