variable "aws_profile" {
  description = "Specifies the AWS CLI profile to use for Terraform operations." 
  # use export AWS_PROFILE=backup
  type    = string
  default = " " # Default to the AWS CLI default profile. Users can override as needed.
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type = string
}

variable "project_name" {
  type    = string
  default = "fastAPI-kube-app"
  description = "Name of the project."
}
