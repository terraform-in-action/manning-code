terraform {
  required_version = "~> 0.12"
  required_providers {
    aws    = "~> 2.45"
    random = "~> 2.2"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "petstore" {
  source = "scottwinkler/petstore/aws"
}

output "address" {
  value = module.petstore.address
}
