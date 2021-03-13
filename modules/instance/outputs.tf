output "id" {
  value = aws_instance.id
}

output "public_ip" {
  value = aws_instance.public_ip
}

output "smtp_username" {
  description = "SMTP username"
  value       = aws_iam_access_key.ses_smtp.id
}

output "smtp_password" {
  description = "SMTP password"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
