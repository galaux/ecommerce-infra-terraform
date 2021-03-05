variable "dns_zone_id" {
  type = string
}

variable "dkim_tokens" {
  description = "Generated DKIM tokens"
  type        = list(string)
}

variable "parent_domain" {
  description = "Parent domain name"
  type        = string
}

variable "use_eip" {
  type        = bool
  description = "Whether or not to use an Elastic IP between the DNS and the instance"
}

variable "target_instance_id" {
  type        = string
  description = "ID of the EC2 instance that DNS entries must point at (used if instructed to use an Elastic ip)"
}

variable "target_public_ip" {
  type        = string
  description = "Public IP that DNS entries must point at (used if instructed NOT to use an Elastic ip)"
}

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}
