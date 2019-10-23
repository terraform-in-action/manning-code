module "aws" {
  source               = "scottwinkler/nomad/aws"
  associate_public_ips = true

  consul = {
    version              = "1.6.1"
    servers_count        = 3
    server_instance_type = "t3.micro"
  }

  nomad = {
    version              = "0.9.5"
    servers_count        = 3
    server_instance_type = "t3.micro"
    clients_count        = 3
    client_instance_type = "t3.micro"
  }
}


module "azure" {
  source               = "scottwinkler/nomad/azure"
  azure                = var.azure
  associate_public_ips = true
  join_wan             = module.aws.public_ips.consul_servers

  consul = {
    version              = "1.6.1"
    servers_count        = 3
    server_instance_size = "Standard_A1"
  }

  nomad = {
    version              = "0.9.5"
    servers_count        = 3
    server_instance_size = "Standard_A1"
    clients_count        = 3
    client_instance_size = "Standard_A1"
  }
}
