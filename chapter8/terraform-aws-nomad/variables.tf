variable "consul" {
    default = {
        version = "1.5.2"
        servers_count = 1
    }
    type = object({
        version = string
        servers_count = number
    })
}

variable "nomad" {
    default = {
        version = "0.9.3"
        servers_count = 1
        clients_count = 0
    }
    type = object({
        version = string
        servers_count = number
        clients_count = number
    })
}

variable "region" {
    default = "us-west-2"
    type = string
}

variable "namespace" {
    default = "nomad"
    type = string
}

variable "ssh_keypair" {
    default = "swinkler"
    type = string
}