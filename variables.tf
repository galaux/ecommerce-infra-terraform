# variable "instance_name" {
#   description = "Value of the Name tag for the EC2 instance"
#   type        = string
#   default     = "ExampleInstance"
# }

variable "open_ports" {
  description = "TODO"
  type        = list(string)
  default = [
    "21",
    "22",
    "25",
    "80",
    "443",
    "22"
  ]
}
