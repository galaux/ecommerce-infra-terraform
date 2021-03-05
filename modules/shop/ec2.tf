resource "aws_security_group" "main" {
  name        = var.name
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

resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.name
  }
}
