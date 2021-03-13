output "name" {
  description = "Name of this EC2 instance"
  value       = aws_instance.main.tags["Name"]
}

output "id" {
  description = "ID of this EC2 instance"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "Public IP of this EC2 instance"
  value       = aws_instance.main.public_ip
}

output "public_dns" {
  description = "Public DNS of this EC2 instance"
  value       = aws_instance.main.public_dns
}

output "smtp_username" {
  description = "SMTP username"
  value       = aws_iam_access_key.ses_smtp.id
}

output "smtp_password" {
  description = "SMTP password"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
}
