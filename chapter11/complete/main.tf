variable "aws" {
  type = object({ access_key = string, secret_key = string, region = string })
}

variable "vcs_repo" {
  type = object({ identifier = string, branch = string, oauth_token = string })
}

provider "aws" {
  access_key = var.aws.access_key
  secret_key = var.aws.secret_key
  region     = var.aws.region
}

module "s3backend" {
  source = "scottwinkler/s3backend/aws"
}

module "codepipeline" {
  source     = "./modules/codepipeline"
  name       = "terraform-in-action"
  vcs_repo   = var.vcs_repo
  auto_apply = true
  environment = {
    AWS_ACCESS_KEY_ID     = var.aws.access_key
    AWS_SECRET_ACCESS_KEY = var.aws.secret_key
    CONFIRM_DESTROY       = 1
  }
  s3_backend_config = module.s3backend.config
}
