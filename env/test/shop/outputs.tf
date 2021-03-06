output "dns_records" {
  description = "DNS records info"
  value       = module.dns_records
}

output "instances" {
  description = "Instances info"
  value = {
    for instance in data.aws_instance.instances : instance.instance_tags.Name => {
      id            = instance.id
      smtp_password = module.shop[instance.instance_tags.Name].smtp_password
    }
  }
}

