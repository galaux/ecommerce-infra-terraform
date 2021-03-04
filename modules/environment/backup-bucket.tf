resource "aws_s3_bucket" "backup" {
  # FIXME change this to `"backup/${var.name}"`
  bucket = "shop-backup-test"
  acl    = "private"
}
