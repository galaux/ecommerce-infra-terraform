variable "name" {
  type = string
}

variable "ami" {
  type        = string
  description = "EC2 AMI identifier"
  default     = "ami-08b6d44b4f6f7b279"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type (\"t2.micro\", …)"
  default     = "t2.micro"
}

variable "open_ports_ipv4" {
  type = list(string)
  default = [
    "21",
    "22",
    "25",
    "80",
    "443",
    "22"
  ]
}

variable "open_ports_ipv6" {
  type = list(string)
  default = [
    "80",
    "443"
  ]
}

variable "backup_bucket_arn" {
  type        = string
  description = "ARN of the bucket where the backup files are stored"
}

variable "key_name" {
  type        = string
  description = "Name of the key to connect to the instance"
}
