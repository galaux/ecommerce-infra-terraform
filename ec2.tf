resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  # vpc_id      = aws_vpc.main.id

  # ingress
  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  # ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0", "::/0"]
  }

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = [aws_vpc.main.cidr_block]
  # }

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
    Name = var.instance_name
  }
}
