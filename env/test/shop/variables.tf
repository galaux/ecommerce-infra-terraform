variable "environment" {
  type        = string
  description = "The name of this environment (\"test\" or \"prod\")"
}

variable "instances" {
  type = map(object({
    parent_domain = string,
    use_eip       = bool
  }))
  description = "Map of instances with their associated configuration"
}
