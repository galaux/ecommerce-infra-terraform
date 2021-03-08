variable "name" {
  type        = string
  description = "The name of this environment"
}

variable "public_key" {
  type        = string
  description = "Public key used for authentication"
}

variable "backup_bucket_name" {
  type        = string
  description = "The name of the S3 bucket used to store backup files"
}
