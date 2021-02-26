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

resource "aws_instance" "std_ec2" {
  ami                    = "ami-08b6d44b4f6f7b279"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.std_ec2.id]
  key_name               = "example-test"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
}

# We might want to avoid having an EIP for test instances as these must be paid
# for if not assigned to a running instance. For test instances, we might want
# to directly have the DNS records point at the EC2 instance public IP.
# TODO maybe don't use an EIP for test instances
resource "aws_eip" "std_ec2" {
  instance = aws_instance.std_ec2.id
  vpc      = true
}
