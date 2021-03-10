# Used to craft the ARN of the CloudWatch action that stops test EC2 instances
variable "aws_account_id" {
  type        = string
  description = "ID of the AWS account"
}

variable "environment" {
  type        = string
  description = "The name of this environment (\"test\" or \"prod\")"
}

variable "instances" {
  type = map(object({
    stop_if_unused : bool
  }))
  description = "List of instance names to provision"
}


variable "dns_records" {
  type = map(object({
    instance = string,
    use_eip  = string
  }))
  description = "Map of instances with their associated configuration"
}
