# This structure is the exact output of what module zone_base produces
variable "zone_base" {
  description = "Base zone configuration"
  type = object({
    dns_zone_id   = string
    dkim_tokens   = list(string)
    parent_domain = string
  })
}

variable "use_eip" {
  type        = bool
  description = "Whether this set of DNS records should rely on an Elastic IP or if they should directly point at the instance public IP"
}

variable "instance" {
  type = object({
    public_ip = string
    id        = string
    tags      = map(string)
  })
  description = "Instance detail"
}

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}
