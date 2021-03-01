output "std_tk_delegation_set_name_servers" {
  description = "Set of name servers (NS) to set in the registrar configuration"
  value       = aws_route53_delegation_set.main.name_servers
}

# output "std_tk_zone_id" {
#   description = "Route53 Zone ID"
#   value       = aws_route53_zone.std_tk.zone_id
# }

output "ec2_std_ip" {
  value = local.ec2_std_ip
}

output "ec2_std_dns" {
  value = local.ec2_std_dns
}

# output "s3_std_backup_test_id" {
#   description = "ID of the bucket where the example Prestashop data is saved"
#   value       = aws_s3_bucket.std_backup_test.id
# }

output "smtp_password" {
  description = "Password for the SES SMTP allowed user"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
