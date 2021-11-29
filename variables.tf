# provider

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc-cidr" {
  type = string
}


# environment

variable "environment" {
  type    = string
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

variable "instance_size" {
  type = map(string)
}

variable "asg_max_size" {
  type = map(string)
}

variable "asg_min_size" {
  type = map(string)
}


### lambdas

variable "filename" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "filename_delete" {
  type = string
}

variable "lambda_handler_delete" {
  type = string
  default = "delete_items.lambda_handler"
}

variable "lambda_handler" {
  type    = string
  default = "main.lambda_handler"
}

variable "lambda_function_name_delete" {
  type = string
}

######## locals

locals {
  common_tags = {
    Owner : "Manuel Rodriguez"
    Project : "Tech Test",
    Environment : terraform.workspace
  }
}



