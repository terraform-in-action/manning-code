terraform {
  required_version = "> 0.14"
  required_providers {
    aws    = "~> 3.22"
    random = "~> 3.0"
  }
}


provider "aws" {
  region  = "us-west-2"
}

module "petstore" {
  source = "terraform-in-action/petstore/aws"
}

output "address" {
  value = module.petstore.address
}

