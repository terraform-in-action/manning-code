resource "azurerm_resource_group" "default" {
  name     = local.namespace
  location = var.location
}