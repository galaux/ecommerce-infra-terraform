variable "name" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "public_key" {
  type        = string
  description = "Public key used for authentication"
}
