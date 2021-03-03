variable "name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
}

variable "parent_domain" {
  type        = string
  description = "Parent domain name (\"example.xyz\")"
}

variable "public_key" {
  type        = string
  description = "Public key used for authentication"
}
