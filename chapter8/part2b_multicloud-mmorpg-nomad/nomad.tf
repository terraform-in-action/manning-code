terraform {
  required_version = "~> 0.12"
  required_providers {
    nomad = "~> 1.4"
  }
}

provider "nomad" {
  address = "http://terraforminaction-7p7ma0-nomad-398143868.us-west-2.elb.amazonaws.com:4646"
  alias   = "aws"
}

provider "nomad" {
  address = "http://terraforminaction-t2ndbv-nomad.westus.cloudapp.azure.com:4646"
  alias   = "azure"
}

module "mmorpg" {
  source   = "scottwinkler/mmorpg/nomad"
  fabio_db = "tcp://terraforminaction-t2ndbv-fabio.westus.cloudapp.azure.com:27017"
  fabio_lb = "http://terraforminaction-7p7ma0-fabio-6ad80758f451730b.elb.us-west-2.amazonaws.com:9999"
  providers = {
    nomad.aws   = "nomad.aws"
    nomad.azure = "nomad.azure"
  }
}

output "browserquest_address" {
  value = module.mmorpg.browserquest_address
}
