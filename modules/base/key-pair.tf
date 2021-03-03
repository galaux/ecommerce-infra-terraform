resource "aws_key_pair" "example_test" {
  key_name   = "example-test"
  public_key = var.public_key
}
