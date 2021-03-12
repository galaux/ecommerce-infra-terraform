# This structure is the exact output of what module zone_base produces
variable "zone_base" {
  description = "Base zone configuration"
  type = object({
    dns_zone_id   = string
    dkim_tokens   = list(string)
    parent_domain = string
  })
}

variable "target_ip" {
  type        = string
  description = "Target IP of these DNS records"
}

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}
