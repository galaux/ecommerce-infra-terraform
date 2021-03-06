# This structure is the exact output of what module dns produces
variable "dns" {
  description = "DNS configuration"
  type = object({
    dns_zone_id   = string
    dkim_tokens   = list(string)
    parent_domain = string
  })
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
