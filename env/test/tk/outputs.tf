output "dns_zone_id" {
  description = "ID of the DNS zone"
  value       = module.base.dns_zone_id
}

output "delegation_set_name_servers" {
  description = "Set of name servers (NS) to set in the registrar configuration"
  value       = module.base.delegation_set_name_servers
}

output "dkim_tokens" {
  description = "Generated DKIM tokens"
  value       = module.base.dkim_tokens
}
