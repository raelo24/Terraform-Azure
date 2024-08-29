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
  sql_server_admin_password = var.sql_server_password
  sql_database_sku_name     = local.sqlserverdb[var.env].sql_database_sku_name
  database_list             = local.sqlserverdb[var.env].sql_databases
  tags                      = local.tags
}

module "azure_function" {
  source                     = "./modules/function-app"
  function_list              = local.azure_function_list
  resource_group_name        = module.resource_group.rg_name
  resource_group_location    = module.resource_group.rg_location
  storage_name               = module.storage.storagename
  storage_account_access_key = module.storage.accesskey
  service_plan_id            = module.service_plan.appserviceplanid
  tags                       = local.tags
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

module "app-insights" {
  source              = "./modules/application-insights"
  app_insights_name   = local.app_insights.name
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  application_type    = local.app_insights.application_type
  tags                = local.tags
}

module "application_gateway" {
  source                  = "./modules/application-gateway"
  agw_name                = local.app_gateway[var.env].agw_name
  agw_sku_tier            = local.app_gateway[var.env].agw_sku_tier
  agw_sku_name            = local.app_gateway[var.env].agw_sku_name
  location                = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  vnet_address_space      = local.app_gateway[var.env].vnet_address_space
  subnet_address_prefixes = local.app_gateway[var.env].subnet_address_prefixes
  custom_probe_path       = local.app_gateway[var.env].probe_path
  path_rules              = local.app_gateway[var.env].path_rules
  identity_type           = local.app_gateway[var.env].agw_identity_type
  enable_waf              = local.app_gateway[var.env].enable_waf
  tags                    = local.tags
}

module "service_bus" {
  source              = "./modules/service-bus"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  servicebus_sku      = var.servicebus-sku
  servicebus_name     = local.servicebus_name
  tags                = local.tags
}


module "keyvault" {
  source                  = "./modules/key-vault"
  kv_name                 = local.keyvault.name
  resource_group_location = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  tags                    = local.tags
  sku_name                = "standard"
  Keyvault_secret         = local.keyvault.secrets
}
