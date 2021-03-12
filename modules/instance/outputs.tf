# Used by module dns_records to setup an EIP when instructed to use one
output "instance_id" {
  value = aws_instance.main.id
}

output "smtp_username" {
  description = "SMTP username"
  value       = aws_iam_access_key.ses_smtp.id
}

output "smtp_password" {
  description = "SMTP password"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
