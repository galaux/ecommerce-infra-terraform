output "ec2_std_ip" {
  value = local.ec2_std_ip
}

output "ec2_std_dns" {
  value = local.ec2_std_dns
}

output "smtp_password" {
  description = "Password for the SES SMTP allowed user"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
