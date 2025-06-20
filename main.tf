module "resource_group" {
  source   = "./modules/resource-group"
  name     = "${var.resource_group_base_name}-${var.env}"
  location = var.resource_group_location
  tags     = local.tags
}

module "service_plan" {
  source                  = "./modules/app-service-plan"
  app_service_plan_name   = local.service_plan[var.env].name
  sku                     = local.service_plan[var.env].sku
  resource_group_location = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  tags                    = local.tags
  os_type                 = local.service_plan[var.env].os
}

module "storage" {
  source                   = "./modules/storage"
  storage_name             = "${local.org}${var.env}storage"
  container_list           = local.storage_containers
  resource_group_location  = module.resource_group.rg_location
  resource_group_name      = module.resource_group.rg_name
  storage_replication_type = var.storage-acc-replication-type
  storage_account_tier     = var.storage-account-tier
  tags                     = local.tags
}

module "sql_server_db" {
  source                    = "./modules/sql-server-db"
  sql_server_name           = local.sqlserverdb[var.env].sql_server_name
  resource_group_name       = module.resource_group.rg_name
  location                  = module.resource_group.rg_location
  sql_database_collation    = local.sqlserverdb[var.env].sql_database_collation
  sql_server_version        = local.sqlserverdb[var.env].sql_server_version
  sql_server_admin_username = var.sql_server_username
  sql_server_admin_password = base64encode(var.sql_server_password)
  sql_database_sku_name     = local.sqlserverdb[var.env].sql_database_sku_name
  database_list             = local.sqlserverdb[var.env].sql_databases
  tags                      = local.tags
}

module "azure_function" {
  source                        = "./modules/function-app"
  function_list                 = local.azure_function_list
  resource_group_name           = module.resource_group.rg_name
  resource_group_location       = module.resource_group.rg_location
  storage_name                  = module.storage.storagename
  storage_account_access_key    = module.storage.accesskey
  service_plan_id               = module.service_plan.appserviceplanid
  app_insights_connectionstring = module.app-insights.connection_stromg
  app_insights_key              = module.app-insights.instrumentation_key
  tags                          = local.tags
  env                           = var.env
  service_bus_connection_string = module.service_bus.connection_string
  storage_connection_string     = module.storage.blobconnectionstring
  depends_on = [
    module.storage, module.service_plan, module.app-insights, module.service_bus
  ]
}

module "redis_cache" {
  source               = "./modules/redis-cache"
  redis_cache_name     = local.redis_cache[var.env].name
  resource_group_name  = module.resource_group.rg_name
  location             = module.resource_group.rg_location
  redis_cache_family   = local.redis_cache[var.env].family
  redis_cache_sku_name = local.redis_cache[var.env].sku
  tags                 = local.tags
}

module "analytics_workspace" {
  source              = "./modules/analytics-workspace"
  workspace_name      = local.analytics_workspace[var.env].name
  location            = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  analytics_sku       = local.analytics_workspace[var.env].sku
  data_retention_days = local.analytics_workspace[var.env].data_retention_days
  tags                = local.tags
}

module "app-insights" {
  source              = "./modules/application-insights"
  app_insights_name   = local.app_insights.name
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  application_type    = local.app_insights.application_type
  workspace_id        = module.analytics_workspace.workspace_id
  tags                = local.tags
  depends_on          = [module.analytics_workspace]
}

module "application_gateway" {
  source                  = "./modules/application-gateway"
  agw_name                = local.app_gateway[var.env].agw_name
  agw_sku_tier            = local.app_gateway[var.env].agw_sku_tier
  agw_sku_name            = local.app_gateway[var.env].agw_sku_name
  location                = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  vnet_address_space      = local.app_gateway[var.env].vnet_address_space
  subnet_address_prefixes = local.app_gateway[var.env].subnet_prefixes
  identity_type           = local.app_gateway[var.env].agw_identity_type
  enable_waf              = local.app_gateway[var.env].enable_waf
  tags                    = local.tags
  backend_config          = local.web_application[var.env].services
  enabled_metrics         = local.app_gateway[var.env].enabled_metrics
  enabled_logs            = local.app_gateway[var.env].enabled_logs
  workspace_id            = module.analytics_workspace.workspace_id
}

module "service_bus" {
  source              = "./modules/service-bus"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  servicebus_sku      = var.servicebus-sku
  servicebus_name     = "${local.org}${var.env}sb"
  topic_subscriptions = local.servicebus
  tags                = local.tags
}

module "keyvault" {
  source                  = "./modules/key-vault"
  kv_name                 = local.keyvault.name
  resource_group_location = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  tags                    = local.tags
  sku_name                = local.keyvault.sku_name
  Keyvault_secrets        = local.keyvault.secrets
}


module "nat_gateway" {
  source              = "./modules/nat-gateway"
  location            = module.resource_group.rg_location
  resource_group_name = module.resource_group.rg_name
  subnet_prefixes     = local.web_application[var.env].subnet_prefixes
  vnet_name           = module.application_gateway.vnet_name
  depends_on = [
    module.application_gateway
  ]
}

module "webapp" {
  source                     = "./modules/web-app"
  location                   = module.resource_group.rg_location
  resource_group             = module.resource_group.rg_name
  appinsight_connection      = module.app-insights.connection_stromg
  appinsight_key             = module.app-insights.instrumentation_key
  keyvault_id                = module.keyvault.keyvaultid
  redis_cache_connection     = module.redis_cache.connectionstring
  service_bus_connection     = module.service_bus.connection_string
  service_plan_id            = module.service_plan.appserviceplanid
  vnet_route_all_enabled     = true
  storage_account_access_key = module.storage.accesskey
  managed_identity_id        = module.application_gateway.managed_identity_id
  sql_server_name            = local.sqlserverdb[var.env].sql_server_name
  sql_server_username        = var.sql_server_username
  services                   = local.web_application[var.env].services
  environment                = var.env
  websockets_enabled         = true
  appservice_subnet          = module.nat_gateway.appservice_subnet_id
  depends_on = [
    module.app-insights, module.application_gateway,
    module.service_plan, module.keyvault, module.redis_cache,
    module.nat_gateway
  ]
}
