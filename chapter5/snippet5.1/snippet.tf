resource "azurerm_template_deployment" "template_deployment" {
  name                = "terraform-ARM-deployment"
  resource_group_name = azurerm_resource_group.resource_group.name
  template_body       = file("${path.module}/templates/iot.json")
  deployment_mode     = "Incremental"

  parameters = {
    IotHubs_my_iot_hub_name = "ghetto-iot-hub"
  }
}