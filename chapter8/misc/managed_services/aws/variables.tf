variable "namespace" {
    default = "terraforminaction"
    type = string
}

variable "app" {
    type = object({
        port = number
        image = string
        command = string
    })
}