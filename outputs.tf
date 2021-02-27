output "std_tk_delegation_set_name_servers" {
  description = "Set of name servers (NS) to set in the registrar configuration"
  value       = aws_route53_delegation_set.main.name_servers
}

# output "std_tk_zone_id" {
#   description = "Route53 Zone ID"
#   value       = aws_route53_zone.std_tk.zone_id
# }

output "std_ec2_eip" {
  description = "Elastic IP of the example EC2 instance"
  value       = aws_eip.std_ec2.public_ip
}

output "std_ec2_public_dns" {
  description = "Elastic IP of the example EC2 instance"
  value       = aws_eip.std_ec2.public_dns
}

# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.std_ec2.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.std_ec2.public_ip
# }

# output "s3_std_backup_test_id" {
#   description = "ID of the bucket where the example Prestashop data is saved"
#   value       = aws_s3_bucket.std_backup_test.id
# }

