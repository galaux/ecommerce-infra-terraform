resource "aws_security_group" "std_ec2" {
  name        = "std_ec2"
  description = "Allow TLS inbound traffic"
  # vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    iterator = port
    for_each = var.open_ports_ipv4
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    iterator = port
    for_each = var.open_ports_ipv6
    content {
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # ie "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami                    = "ami-08b6d44b4f6f7b279"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.std_ec2.id]
  key_name               = "example-test"
}
