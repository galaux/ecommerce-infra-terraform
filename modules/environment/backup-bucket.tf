resource "aws_s3_bucket" "backup" {
  bucket = var.backup_bucket_name
  acl    = "private"
}
