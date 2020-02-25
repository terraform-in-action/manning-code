provider "aws" {
  profile = "<profile>"
  region  = "us-west-2"
}

variable "live" {
  default = "green"
}

module "base" {
  source = "./modules/base"
  live   = var.live
}

module "green" {
  source      = "./modules/autoscaling"
  app_version = "v1.0"
  label       = "green"
  base        = module.base
}

module "blue" {
  source      = "./modules/autoscaling"
  app_version = "v2.0"
  label       = "blue"
  base        = module.base
}

output "lb_dns_name" {
  value = module.base.lb_dns_name
}
