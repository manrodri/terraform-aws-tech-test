# provider

variable "region" {
  type = string
  default = "eu-west-1"
}

variable "vpc-cidr" {
  type = string
}


# environment

variable environment {
  type = string
  default = "development"
}

# VPC

variable "subnet_count" {
  type = map(number)
}
variable "private_subnets" {}
variable "public_subnets" {}

# Compute


# for the purpose of this exercise use the default key pair on your local system
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable instance_size {
  type = map(string)
}

variable "asg_max_size" {
  type = map(string)
}

variable "asg_min_size" {
  type = map(string)
}


######## locals

locals {
  common_tags = {
    Owner: "Manuel Rodriguez"
    Project: "Tech Test",
    Environment: terraform.workspace
  }
}



