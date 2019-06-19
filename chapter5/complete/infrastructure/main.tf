module "pipeline-dev" {
  source = "./modules/pipeline"
  namespace = "${var.namespace}-dev"
}

module "pipeline-int" {
  source = "./modules/pipeline"
  namespace = "${var.namespace}-int"
  repo = {
    
  }
}

module "pipeline-prod" {
  source = "./modules/pipeline"
  namespace = "${var.namespace}-prod"
}