# Used to craft the ARN of the CloudWatch action that stops test EC2 instances
variable "aws_account_id" {
  type        = string
  description = "ID of the AWS account"
}

variable "environment" {
  type        = string
  description = "The name of this environment (\"test\" or \"prod\")"
}

variable "http_allowed_ips" {
  type        = list(string)
  description = "List IPs white listed to access HTTP(S) ports"
}
