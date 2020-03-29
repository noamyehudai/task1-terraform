variable "instance_type" {
  description = "The type of EC2 Instnaces to run in the ASG (e.g. t2.micro)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy to (e.g. ec-central-1)"
  type        = string
}
