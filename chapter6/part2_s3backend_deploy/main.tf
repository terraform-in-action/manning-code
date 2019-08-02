provider "aws" {
  region  = "us-west-2"
  profile = "swinkler"
}

module "s3backend" {
  source = "scottwinkler/s3backend/aws"
  namespace     = "pokemon"
}

output "s3backend_config" {
  value = module.s3backend.config
}

/*
module "github_test" {
    source ="github.com/scottwinkler/terraform-aws-s3backend"
    
    account_id = "215974853022"
    force_destroy = true
}*/
