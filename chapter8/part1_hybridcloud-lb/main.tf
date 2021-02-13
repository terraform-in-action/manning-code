module "aws" {
  source = "terraform-in-action/vm/cloud//modules/aws" #A
  environment = { 
    name             = "AWS" #B
    background_color = "orange" #B
  }
}

module "azure" {
  source = "terraform-in-action/vm/cloud//modules/azure" #A
  environment = {
    name             = "Azure"
    background_color = "blue"
  }
}

module "gcp" {
  source     = "terraform-in-action/vm/cloud//modules/gcp" #A
  environment = {
    name             = "GCP"
    background_color = "red"
  }
}

module "loadbalancer" {
  source = "terraform-in-action/vm/cloud//modules/loadbalancer" #A
  addresses = [
    module.aws.network_address, #C
    module.azure.network_address, #C
    module.gcp.network_address, #C
  ]
}
