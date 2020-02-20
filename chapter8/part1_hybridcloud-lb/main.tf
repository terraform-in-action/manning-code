module "aws" {
  source = "scottwinkler/vm/cloud//modules/aws"
  environment = {
    name             = "AWS"
    background_color = "orange"
  }
}

module "azure" {
  source = "scottwinkler/vm/cloud//modules/azure"
  environment = {
    name             = "Azure"
    background_color = "blue"
  }
}

module "gcp" {
  source     = "scottwinkler/vm/cloud//modules/gcp"
  project_id = var.gcp.project_id
  environment = {
    name             = "GCP"
    background_color = "red"
  }
}

module "loadbalancer" {
  source = "scottwinkler/vm/cloud//modules/loadbalancer"
  addresses = [
    module.aws.network_address,
    module.azure.network_address,
    module.gcp.network_address,
  ]
}