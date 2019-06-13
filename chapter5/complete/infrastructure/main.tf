module "helloworld-pipeline" {
  source = "./modules/pipeline"
  namespace = var.namespace
}