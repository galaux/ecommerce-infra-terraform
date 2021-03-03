variable "name" {
  type = string
  # default = ""
}

variable "test_environment" {
  type    = bool
  default = true
}

variable "dns_zone_id" {
  type = string
}

# variable "instance_name" {
#   description = "Value of the Name tag for the EC2 instance"
#   type        = string
#   default     = "ExampleInstance"
# }

variable "open_ports_ipv4" {
  type = list(string)
  default = [
    "21",
    "22",
    "25",
    "80",
    "443",
    "22"
  ]
}

variable "open_ports_ipv6" {
  type = list(string)
  default = [
    "80",
    "443"
  ]
}

variable "parent_domain" {
  type        = string
  description = "Parent domain name (\"example.xyz\")"
}

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}

variable "dkim_tokens" {
  description = "Generated DKIM tokens"
  type        = list(string)
}

variable "backup_bucket_arn" {
  type        = string
  description = "ARN of the bucket where the backup files are stored"
}

