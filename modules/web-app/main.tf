# data "azurerm_key_vault_secret" "db_passwprd" {
#   name         = "db-password"
#   key_vault_id = var.keyvault_id
# }

locals {
  sql_server_password = "" //data.azurerm_key_vault_secret.db_passwprd.value  
  api_services = {
    for config in var.services :
    config.api => config.db_name
  }
}

resource "azurerm_linux_web_app" "webapp" {
  for_each            = local.api_services
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group
  service_plan_id     = var.service_plan_id

  site_config {
    minimum_tls_version    = "1.2"
    http2_enabled          = true
    vnet_route_all_enabled = var.vnet_route_all_enabled
    websockets_enabled     = var.websockets_enabled
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  //configure settings here to match your db
  connection_string {
    name  = "DbConnection"
    type  = "SQLServer"
    value = "Server=tcp:${var.sql_server_name}.database.windows.net,1433; Initial Catalog=${each.value};Persist Security Info=False; User ID=${var.sql_server_username};Password=${local.sql_server_password}"
  }

  app_settings = {
    "Environment"                 = var.environment == "prod" ? "Production" : "Development"
    "RedisCacheConnection"        = var.redis_cache_connection
    "ApplicationInsightKey"       = var.appinsight_connection
    "ApplicationInsighConnection" = var.appinsight_connection
    "StorageAccountConnection"    = var.storage_account_access_key
    "ServiceBusConnection"        = var.service_bus_connection
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  for_each       = length(local.api_services) > 0 ? azurerm_linux_web_app.webapp : {}
  app_service_id = each.value.id
  subnet_id      = var.appservice_subnet
}
