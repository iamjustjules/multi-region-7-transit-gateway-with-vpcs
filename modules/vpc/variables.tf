variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "region_name" {
  description = "Name of the region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "extra_private_routes" {
  description = "Additional routes for private route table"
  type = list(object({
    cidr_block         = string
    transit_gateway_id = string
  }))
  default = []
}

variable "public_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = map(string)
}

variable "private_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = map(string)
} 

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}