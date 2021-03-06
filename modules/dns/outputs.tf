# The complete output of this module is passed raw as input variable to module
# `dns_records` which is thus expecting this exact format (except for
# `delegation_set_name_servers`) so changes to this file must also be applied
# to `module.dns_records.dns`.

output "parent_domain" {
  description = "Parent domain for this DNS"
  value       = var.parent_domain
}

output "dns_zone_id" {
  description = "ID of the DNS zone"
  value       = aws_route53_zone.main.zone_id
}

output "delegation_set_name_servers" {
  description = "Set of name servers (NS) to set in the registrar configuration"
  value       = aws_route53_delegation_set.main.name_servers
}

output "dkim_tokens" {
  description = "Generated DKIM tokens"
  value       = aws_ses_domain_dkim.main.dkim_tokens
}
