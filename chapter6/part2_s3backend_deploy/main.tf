provider "aws" {
  region  = "us-west-2"
}

module "s3backend" {
  source    = "terraform-in-action/s3backend/aws"
  namespace = "team-rocket"
}

output "s3backend_config" {
  value = module.s3backend.config
}