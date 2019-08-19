module "resourcegroup" {
    source = "./modules/resourcegroup"

    namespace = var.namespace
}

module "nomad_servers" {
    source = "./modules/autoscaling"

    namespace = var.namespace
    ssh_keypair = var.ssh_keypair
    instance_count = var.nomad.servers_count 
    nomad = {
        version = var.nomad.version
        mode = "server"
    }
    consul = {
        version = var.consul.version
        mode = "client"
    }
    vpc = module.networking.vpc
    sg = module.networking.sg
    target_group_arns = [module.loadbalancing.nomad_group_arn]
}

module "nomad_clients" {
    source = "./modules/autoscaling"

    namespace = var.namespace
    ssh_keypair = var.ssh_keypair
    instance_count = var.nomad.clients_count
    nomad = {
        version = var.nomad.version
        mode = "client"
    }
    consul = {
        version = var.consul.version
        mode = "client"
    }
    vpc = module.networking.vpc
    sg = module.networking.sg
}

module "consul_servers" {
    source = "./modules/autoscaling"

    namespace = var.namespace
    ssh_keypair = var.ssh_keypair
    instance_count = var.consul.servers_count
    nomad = {
        version = var.nomad.version
        mode = "client"
    }
    consul = {
        version = var.consul.version
        mode = "server"
    }
    vpc = module.networking.vpc
    sg = module.networking.sg
    target_group_arns = [module.loadbalancing.consul_group_arn]
}

module "networking" {
    source = "./modules/networking"

    namespace = var.namespace
}

module "loadbalancing" {
    source = "./modules/loadbalancing"

    namespace = var.namespace
    vpc = module.networking.vpc
    sg = module.networking.sg
}