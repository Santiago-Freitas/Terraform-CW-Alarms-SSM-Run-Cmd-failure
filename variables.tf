variable "aws_region" {
  description = "Region to provision resources"
  type        = string
  default     = "us-east-1"
}

variable "email_to_notify" {
  description = "email to notify when there is an error"
  type        = string
  default     = ""
}

