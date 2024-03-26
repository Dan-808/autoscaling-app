variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"

}

variable "aws_profile" {
  type        = string
  description = ""
  default     = "user-cli"

}

variable "serice_name" {
  type        = string
  description = ""
  default     = "autoscaling-app"

}

variable "instance_type" {
  type        = string
  description = ""
  default     = "t2.micro"

}
