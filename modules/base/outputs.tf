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

output "backup_bucket_arn" {
  description = "ARN of the bucket where the backup files are stored"
  value       = aws_s3_bucket.backup.arn
}
