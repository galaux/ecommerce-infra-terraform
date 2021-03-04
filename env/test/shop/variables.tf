variable "environment" {
  type        = string
  description = "The name of this environment (\"test\" or \"prod\")"
}

variable "instances" {
  type        = map(object({ parent_domain = string }))
  description = "Map of instances with their associated parent_domain"
}
