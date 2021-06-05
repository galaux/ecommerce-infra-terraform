name       = "prod"
public_key = "ssh-rsa AAAAB3NzaC1yc2EREDACTEDPUBLICKEY example prod"
allowed_admin_arns = [
  # 123456789012: AWS account "alaux"
  "arn:aws:iam::123456789012:user/guillaume"
  # No need to include anything for GDB: his user belongs to this AWS account
]
