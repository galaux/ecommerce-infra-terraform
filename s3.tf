resource "aws_s3_bucket" "std_backup_test" {
  bucket = "shop-backup-test"
  acl    = "private"
}
