terraform {
  required_version = "~> 0.12"
  required_providers {
    aws     = "~> 2.29"
    azurerm = "~> 1.34"
    random  = "~> 2.2"
  }
}

provider "aws" {
  profile = "swinkler"
  region  = "us-west-2"
}

provider "azurerm" {
  subscription_id = "xxx"
  client_id       = "xxx"
  client_secret   = "xxx"
  tenant_id       = "xxx"
}

module "aws" {
  source = "scottwinkler/mmorpg/cloud//aws"
  app = {
    image   = "swinkler/browserquest"
    port    = 8080
    command = "node server.js --connectionString ${module.azure.connection_string}"
  }
}

module "azure" {
  source    = "scottwinkler/mmorpg/cloud//azure"
  namespace = "terraforminaction"
  location  = "westus"
}

output "browserquest_address" {
  value = module.aws.lb_dns_name
}
