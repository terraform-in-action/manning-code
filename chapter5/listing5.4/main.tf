resource "azurerm_resource_group" "default" {
  name     = var.namespace
  location = var.region
}