output "vpc" {
    value = module.vpc
}

output "sg" {
    value = {
        loadbalancer = module.loadbalancer_sg.security_group.id
        server = module.server_sg.security_group.id
    }
}