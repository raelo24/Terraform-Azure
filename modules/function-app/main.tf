resource "azurerm_linux_function_app" "function_app" {
  for_each                   = toset(var.function_list)
  name                       = each.value
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_name
  service_plan_id            = var.service_plan_id
  storage_account_access_key = var.storage_account_access_key
  tags                       = var.tags

  site_config {
    application_insights_connection_string = var.app_insights_connectionstring
    application_insights_key               = var.app_insights_key
    minimum_tls_version                    = "1.2"
    application_stack {
      dotnet_version = "8.0"
    }
  }

  app_settings = {
    "Environment" : var.env == "prod" ? "Production" : "Development"
    "ServiceBusConnection" : var.service_bus_connection_string
    "AzureWebJobsStorage" : var.storage_connection_string
  }
}
