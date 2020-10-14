/// Variables

variable "region" {
    type    = string
    default = "ap-southeast-1"
}

variable "vpc_cidr_range" {
    type    = string
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    type    = list(string)
    default = ["10.0.0.0/24","10.0.1.0/24"]
}

/// Provider

provider "aws" {
    version    = "~>2.0"
    region     = var.region
}

/// Data sources

data "aws_availability_zones" "azs" {}


/// Resources

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "dev-vpc"
  cidr = var.vpc_cidr_range

  azs             = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnets  = var.public_subnets

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

/// Outputs

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
    value = module.vpc.public_subnets
}
