provider "aws" {
  region = "us-west-2"
}

module "webserver" {
  source  = "scottwinkler/webserver/vanilla"
  version = "0.1.3"

  namespace = "chapter1"
}

output "lb_dns_name" {
  value = module.webserver.lb_dns_name
}