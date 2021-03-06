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

variable "instance" {
  type = object({
    public_ip = string
    id        = string
  })
  description = "TODO"
}

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}
