variable "namespace" {
    type = string
}

variable "ssh_keypair" {
    type = string
}

variable "instance_count" {
    type = number
}

variable "nomad" {
    type = object({
        version = string
        mode = string
    })
}

variable "consul" {
    type = object({
        version = string
        mode = string
    })
}

variable "vpc" {
    type = any
}

variable "sg" {
    type = object({
        server = any
        loadbalancer = any
    })
}

variable "target_group_arns" {
    type = list(string)
    default = []
}