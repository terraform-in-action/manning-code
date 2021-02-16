terraform {
  required_version = ">= 0.15"
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 1.4"
    }
  }
}

provider "nomad" { #A
  address = "<aws.addresses.nomad_ui>"
  alias   = "aws"
}

provider "nomad" { #A
  address = "<azure.addresses.nomad_ui>"
  alias   = "azure"
}

module "mmorpg" {
  source   = "terraform-in-action/mmorpg/nomad"
  fabio_db = "<azure.addresses.fabio_db>" #B
  fabio_lb = "<aws.addresses.fabio_lb>" #B
  
  providers = {               #C                                                                        
    nomad.aws   = nomad.aws
    nomad.azure = nomad.azure
  }
}

output "browserquest_address" {
  value = module.mmorpg.browserquest_address
}
