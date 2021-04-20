resource "azurerm_function_app" "function_app" {
  for_each = toset(var.function_list)
  name                       = each.value
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name
  storage_account_name       = var.storage_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_access_key = var.storage_account_access_key
  tags                       = var.tags  

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  site_config {
    always_on = true
  }

  identity {
    type = var.identity_type
  }

  https_only = var.https_only
}
