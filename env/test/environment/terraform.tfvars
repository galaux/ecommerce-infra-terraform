name       = "test"
public_key = "ssh-rsa AAAAB3NzaC1yc2EREDACTEDPUBLICKEY test"
allowed_admin_arns = [
  # 123456789012: AWS account "shop"
  "arn:aws:iam::123456789012:user/owner",
  # 123456789012: AWS account "alaux"
  "arn:aws:iam::123456789012:user/guillaume"
]
