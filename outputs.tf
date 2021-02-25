# output "instance_id" {
#   description = "ID of the EC2 instance"
#   value       = aws_instance.example.id
# }

# output "instance_public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.example.public_ip
# }

output "s3_std_backup_test_id" {
  description = "ID of the bucket where the example Prestashop data is saved"
  value       = aws_s3_bucket.std_backup_test.id
}

