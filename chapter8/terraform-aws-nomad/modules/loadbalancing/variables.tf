variable "namespace" {
  type = string
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