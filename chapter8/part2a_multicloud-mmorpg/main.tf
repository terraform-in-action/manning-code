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
  region  = "us-west-2"
}

provider "azurerm" {
  features {}
}

module "aws" {
  source               = "terraform-in-action/nomad/aws"
  associate_public_ips = true #A

  consul = {
    version              = "1.9.2"
    servers_count        = 3
    server_instance_type = "t3.micro"
  }

  nomad = {
    version              = "1.0.3"
    servers_count        = 3
    server_instance_type = "t3.micro"
    clients_count        = 3
    client_instance_type = "t3.micro"
  }
}


module "azure" {
  source               = "terraform-in-action/nomad/azure"
  location             = "Central US"
  associate_public_ips = true                                 #A
  join_wan             = module.aws.public_ips.consul_servers #B

  consul = {
    version              = "1.9.2"
    servers_count        = 1
    server_instance_size = "Standard_A1_v2"
  }

  nomad = {
    version              = "1.0.3"
    servers_count        = 1
    server_instance_size = "Standard_A1_v2"
    clients_count        = 1
    client_instance_size = "Standard_A1_v2"
  }
}

output "aws" {
  value = module.aws
}
output "az" {
  value = module.azure
}
