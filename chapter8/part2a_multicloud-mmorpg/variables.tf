variable "aws" {
  type = object({
    profile = string
    region  = string
  })
}

variable "azure" {
  type = object({
    subscription_id = string
    client_id       = string
    client_secret   = string
    tenant_id       = string
    location        = string
  })
}
