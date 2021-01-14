variable "vcs_repo" {
  type = object({ identifier = string, branch = string })
}

provider "aws" {
  region  = "us-west-2"
}

module "s3backend" {
  source         = "terraform-in-action/s3backend/aws"
  principal_arns = [module.codepipeline.deployment_role_arn]
}

module "codepipeline" {
  source     = "./modules/codepipeline"
  name       = "terraform-in-action"
  vcs_repo   = var.vcs_repo
  auto_apply = true
  environment = {
    CONFIRM_DESTROY = 1
  }

  deployment_policy = file("./policies/helloworld.json")
  s3_backend_config = module.s3backend.config
}
