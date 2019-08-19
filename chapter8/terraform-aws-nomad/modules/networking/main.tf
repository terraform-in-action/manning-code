data "aws_availability_zones" "available" {}

module "vpc" {
  source                           = "terraform-aws-modules/vpc/aws"
  version                          = "2.5.0"
  name                             = "${var.namespace}-vpc"
  cidr                             = "10.0.0.0/16"
  azs                              = data.aws_availability_zones.available.names
  private_subnets                  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets                   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  assign_generated_ipv6_cidr_block = true
  enable_nat_gateway               = true
  single_nat_gateway               = true
  tags = {
    ResourceGroup = var.namespace
  }
}

module "loadbalancer_sg" {
  source = "scottwinkler/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port        = 8500
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 4646
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "server_sg" {
  source = "scottwinkler/sg/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 8500
      security_groups = [module.loadbalancer_sg.security_group.id]
    },
    {
      port        = 4646
      security_groups = [module.loadbalancer_sg.security_group.id]
    },
    {
      port        = 22
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]
}