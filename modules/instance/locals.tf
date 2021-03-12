locals {

  # We don't use EIP for test EC2 instances (because an EIP not bound to an
  # up-and-running EC2 instance must be paid for). Furthermore, as [this
  # suggests][0], though they ultimately hold the same value,
  # aws_instance.public_ip will be changed to reflect the aws_eip.public_ip.
  #
  # For these reasons, this local track the definitive public IP of the EC2
  # instance whether we are using an EIP or not.
  #
  # [0]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#public_ip
  instance_ip = var.use_eip ? aws_eip.instance[0].public_ip : aws_instance.main.public_ip

  # These curly braces declare a "new object", not a "block of code"!
  open_ports_ipv4 = {
    # These curly braces declare a "new object", not a "block of code"!
    for port in var.open_ports_ipv4 : port => {
      cidr_blocks = contains(["80", "443"], port) ? var.http_allowed_ips : ["0.0.0.0/0"]
    }
  }

}
