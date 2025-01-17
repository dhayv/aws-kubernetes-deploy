variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_sg_id" {
  type = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}