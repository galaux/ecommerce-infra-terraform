variable "zone_base" {
  description = "Base zone configuration"
  type = object({
    dns_zone_id = string
  })
}

variable "mailchimp_dkim_tokens" {
  type    = map(string)
  default = {}
}
