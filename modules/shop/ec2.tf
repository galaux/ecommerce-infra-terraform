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

  tags = {
    Name = var.name
  }
}

# We refrain from using an EIP for test instances as these must be paid for if
# not assigned to a running instance. For test instances, we thus have the DNS
# records point at the EC2 instance public IP directly.
resource "aws_eip" "std_ec2" {
  count    = var.test_environment ? 0 : 1
  instance = aws_instance.std_ec2.id
  vpc      = true
}

locals {
  # We don't use EIP for test EC2 instances (because an EIP not bound to an
  # up-and-running EC2 instance must be paid for). Furthermore, as [this
  # suggests][0], though they ultimately hold the same value,
  # aws_instance.public_ip will be changed to reflect the aws_eip.public_ip.
  #
  # For these reasons, these two locals track the definitive pubilc IP and DNS
  # of the EC2 instance whether we are in test or not.
  #
  # [0]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#public_ip
  ec2_std_ip  = var.test_environment ? aws_instance.std_ec2.public_ip : aws_eip.std_ec2[0].public_ip
  ec2_std_dns = var.test_environment ? aws_instance.std_ec2.public_dns : aws_eip.std_ec2[0].public_dns
}

