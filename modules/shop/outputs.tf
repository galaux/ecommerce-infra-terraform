output "instance_dns" {
  value = local.instance_dns
}

output "smtp_password" {
  description = "Password for the SES SMTP allowed user"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
