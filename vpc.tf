provider "aws" {
  region = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name = "${var.environment}-vpc"
  cidr = var.vpc-cidr

  azs             =  slice(data.aws_availability_zones.available.names, 0, var.subnet_count[terraform.workspace])
  private_subnets = var.private_subnets[terraform.workspace]
  public_subnets  = var.public_subnets[terraform.workspace]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {"Name": "${var.environment}-vpc"})
}






