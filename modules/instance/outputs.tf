output "instance_ip" {
  value = local.instance_ip
}

output "smtp_username" {
  description = "SMTP username"
  value       = aws_iam_access_key.ses_smtp.id
}

output "smtp_password" {
  description = "SMTP password"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
