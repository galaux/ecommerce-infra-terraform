output "parent_domain" {
  description = "Parent domain name (\"example.xyz\")"
  value       = var.parent_domain
}

output "instance_dns" {
  value = aws_instance.main.public_dns
}

# Used by module dns_records to setup an EIP when instructed to use one
output "instance_id" {
  value = aws_instance.main.id
}

# Used by module dns_records to setup DNS when instructed not to use an EIP
output "instance_public_ip" {
  value = aws_instance.main.public_ip
}

output "smtp_password" {
  description = "Password for the SES SMTP allowed user"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
