variable "aws_region" {
  type = string
  default = ""
}

variable "public_subnet_ids" {
  type = list(string)
  default = []
}


variable vpc_security_group_id {
  type = string
  default = ""
}