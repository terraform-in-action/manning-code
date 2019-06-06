module "lb_sg" {
  source  = "scottwinkler/sg/aws"
  version = "1.0.0"
  vpc_id  = module.vpc.vpc_id

  ingress_rules = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
