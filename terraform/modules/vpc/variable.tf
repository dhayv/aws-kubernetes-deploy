variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
  description = "CIDR block for VPC"
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  description = "availabilty zones"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}