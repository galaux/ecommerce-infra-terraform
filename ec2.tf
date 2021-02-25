resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  # vpc_id      = aws_vpc.main.id

  # ingress
  ingress {
    for_each = toset(var.open_ports)

    from_port   = each.key
    to_port     = each.key
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  # egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # ie "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "example" {
  ami             = "ami-08b6d44b4f6f7b279"
  instance_type   = "t2.micro"
  security_groups = ["aws_security_group.allow_tls"]

  tags = {
    Name = var.list
  }
}
