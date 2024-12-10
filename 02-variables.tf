variable "peer_account_id" {
  description = "The AWS account ID of the peer account to share the transit gateway with"
  type        = string
  default     = "011528298515"
}

variable "use_ram_resource_share" {
  default = true
}