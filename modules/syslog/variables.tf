variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_cidrs" {
  type = map(string)
}

variable "common_tags" {
  type = map(string)
}

