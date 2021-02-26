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

