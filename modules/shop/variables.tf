variable "name" {
  type = string
  # default = ""
}

variable "test_environment" {
  type    = bool
  default = true
}

# variable "instance_name" {
#   description = "Value of the Name tag for the EC2 instance"
#   type        = string
#   default     = "ExampleInstance"
# }

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

variable "sub_domains" {
  type = list(string)
  default = [
    "admin",
    "blog",
    "www"
  ]
}

