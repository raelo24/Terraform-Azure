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
  }
}
