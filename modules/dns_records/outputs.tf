output "target_ip" {
  description = "Target IP of the DNS records"
  value       = local.target_ip
}

output "instance_id" {
  description = "ID of the EC2 instance that DNS records point at"
  value       = var.instance.id
}

output "instance_name" {
  description = "Name of the EC2 instance that DNS records point at"
  value       = var.instance.tags.Name
}

output "use_eip" {
  description = "Whether this set of DNS records relies on an Elastic IP or if they directly point at the instance public IP"
  value       = var.use_eip
}
