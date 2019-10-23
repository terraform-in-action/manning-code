resource "azurerm_resource_group" "default" {
  name     = var.namespace
  location = var.region
}

resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = substr(join("-", [var.namespace, random_string.rand.result]), 0, 24)
}
