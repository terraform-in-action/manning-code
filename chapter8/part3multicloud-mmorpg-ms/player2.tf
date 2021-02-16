terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.47"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.28"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "<profile>"
  region = "us-west-2"
}

provider "azurerm" {
  features {}
}

module "aws" {
  source = "terraform-in-action/mmorpg/cloud//aws"
  app = {
    image   = "swinkler/browserquest"
    port    = 8080
    command = "node server.js --connectionString ${module.azure.connection_string}"
  }
}

module "azure" {
  source    = "terraform-in-action/mmorpg/cloud//azure"
  namespace = "terraforminaction"
  location  = "centralus"
}

output "browserquest_address" {
  value = module.aws.lb_dns_name
}
