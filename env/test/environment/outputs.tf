output "backup_bucket_arn" {
  description = "ARN of the bucket where the backup files are stored"
  value       = module.environment.backup_bucket_arn
}
