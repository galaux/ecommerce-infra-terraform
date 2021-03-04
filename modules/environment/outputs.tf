output "backup_bucket_arn" {
  description = "ARN of the bucket where the backup files are stored"
  value       = aws_s3_bucket.backup.arn
}
