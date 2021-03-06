locals {
  # We don't use EIP for test EC2 instances (because an EIP not bound to an
  # up-and-running EC2 instance must be paid for). Furthermore, as [this
  # suggests][0], though they ultimately hold the same value,
  # aws_instance.public_ip will be changed to reflect the aws_eip.public_ip.
  #
  # For these reasons, this local track the definitive public IP of the EC2
  # instance whether we are in test or not.
  #
  # [0]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#public_ip
  target_ip = var.use_eip ? aws_eip.instance[0].public_ip : var.instance.public_ip
}
