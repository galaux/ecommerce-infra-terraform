output "use_eip" {
  description = "Whether this instance/dns link relies on an Elastic IP or if DNS entries directly points at the instance public IP"
  value       = var.use_eip
}
