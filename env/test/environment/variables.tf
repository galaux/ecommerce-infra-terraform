variable "name" {
  type        = string
  description = "The name of this environment"
}

variable "public_key" {
  type        = string
  description = "Public key used for authentication"
}

variable "allowed_admin_arns" {
  type        = list(string)
  description = "List of ARNs allowed to endorse the admin role"
}
