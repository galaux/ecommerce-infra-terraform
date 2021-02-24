resource "aws_instance" "example" {
  ami           = "ami-08b6d44b4f6f7b279"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
