# Modules directory structure:
# modules/
#   alb/
#     main.tf
#     variables.tf
#     outputs.tf
#   asg/
#     main.tf
#     variables.tf
#     outputs.tf
#   syslog/
#     main.tf
#     variables.tf
#     outputs.tf
#   vpc/
#     main.tf
#     variables.tf
#     outputs.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "new_york"
  region = "us-east-1"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "sao_paulo"
  region = "sa-east-1"
}

provider "aws" {
  alias  = "australia"
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "hong_kong"
  region = "ap-east-1"
}

provider "aws" {
  alias  = "california"
  region = "us-west-1"
}

