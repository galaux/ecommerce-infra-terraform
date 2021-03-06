variable "environment" {
  type        = string
  description = "The name of this environment (\"test\" or \"prod\")"
}

variable "instances" {
  type        = set(string)
  description = "List of instance names to provision"
}


variable "dns_records" {
  type = map(object({
    instance = string,
    use_eip  = string
  }))
  description = "Map of instances with their associated configuration"
}
