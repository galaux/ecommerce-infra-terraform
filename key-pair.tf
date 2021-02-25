resource "aws_key_pair" "example_test" {
  key_name   = "example-test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EREDACTEDPUBLICKEY example test"
}

