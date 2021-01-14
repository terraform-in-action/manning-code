locals {
  backend = templatefile("${path.module}/templates/backend.json", { config : var.s3_backend_config, name : local.namespace }) #A

  default_environment = { 
    TF_IN_AUTOMATION  = "1"
    TF_INPUT          = "0"
    CONFIRM_DESTROY   = "0"
    WORKING_DIRECTORY = var.working_directory
    BACKEND           = local.backend,
  }

  environment = jsonencode([for k, v in merge(local.default_environment, var.environment) : { name : k, value : v, type : "PLAINTEXT" }]) #C
}
