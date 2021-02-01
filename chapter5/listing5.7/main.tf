module "ballroom" {
  source = "terraform-in-action/ballroom/azure"
}

resource "azurerm_storage_blob" "storage_blob" {
  name                   = "server.zip"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.storage_container.name
  type                   = "Block"
  source                 = module.ballroom.output_path
}