output "instances" {
  description = "Instances info"
  value = {
    for k, instance in data.aws_instance.instances : instance.instance_tags.Name => {
      id            = instance.id
      public_dns    = instance.public_dns
      parent_domain = module.shop[instance.instance_tags.Name].parent_domain
      smtp_password = module.shop[instance.instance_tags.Name].smtp_password
    }
  }
}

