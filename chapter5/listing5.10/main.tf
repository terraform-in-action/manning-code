resource "azurerm_app_service_plan" "plan" {
  name                = local.namespace
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  kind                = "functionapp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "application_insights" {
  name                = local.namespace
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  application_type    = "web"
}

resource "azurerm_function_app" "function" {
  name                = local.namespace
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  https_only          = true

  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  version                    = "~2"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "node"
    WEBSITE_RUN_FROM_PACKAGE       = local.package_url #A
    WEBSITE_NODE_DEFAULT_VERSION   = "10.14.1"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.application_insights.instrumentation_key
    TABLES_CONNECTION_STRING       = data.azurerm_storage_account_sas.storage_sas.connection_string
    AzureWebJobsDisableHomepage    = true
  }
}