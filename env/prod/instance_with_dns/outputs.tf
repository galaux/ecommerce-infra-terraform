output "instances" {
  description = "Instances info"
  value = {
    for instance in data.aws_instance.instances : instance.instance_tags.Name => {
      id            = instance.id
      smtp_username = module.instance[instance.instance_tags.Name].smtp_username
      smtp_password = module.instance[instance.instance_tags.Name].smtp_password
    }
  }
}

output "dns_records" {
  description = "DNS records info"
  value       = module.dns_records
}
