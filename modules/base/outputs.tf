output "std_tk_delegation_set_name_servers" {
  description = "Set of name servers (NS) to set in the registrar configuration"
  value       = aws_route53_delegation_set.main.name_servers
}

output "dns_zone_id" {
  description = "ID of the DNS zone"
  value       = aws_route53_zone.std_tk.zone_id
}
