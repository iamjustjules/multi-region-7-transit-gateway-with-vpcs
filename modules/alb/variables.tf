variable "region_name" {
  description = "Name of the region"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "time_wait" {
  description = "Time to wait for the target to become active"
  type        = number
}

variable "time_sleep" {
  description = "Time to wait for the next stage to begin"
  type        = number
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "syslog_server_id" {
  description = "IP address of the syslog server"
  type        = string
}

