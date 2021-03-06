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
  description = "Whether this instance/dns link should rely on an Elastic IP or if DNS entries should directly point at the instance public IP"
}

variable "instance" {
  type = object({
    public_ip = string
    id        = string
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
