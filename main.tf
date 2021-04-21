module "resource_group" {
  source   = "./modules/resource-group"
  name     = "${var.resource_group_base_name}-${var.env}"
  location = var.resource_group_location
  tags     = local.tags
}

module "app_service_plan" {
  source                  = "./modules/app-service-plan"
  app_service_plan_name   = local.app_service_plan[var.env].name
  tier                    = local.app_service_plan[var.env].tier
  resource_group_location = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  size                    = local.app_service_plan[var.env].size
}

module "storage" {
  source                   = "./modules/storage"
  storage_name             = "st${local.org}${var.env}"
  container_list           = local.storage_containers
  resource_group_location  = module.resource_group.rg_location
  resource_group_name      = module.resource_group.rg_name
  storage_replication_type = var.storage-acc-replication-type
  storage_account_tier     = var.storage-account-tier
  tags                     = local.tags
}

module "sql_database" {
  source                    = "./modules/sql-server-db"
  sql_server_name           = "${local.sqlserver.sql_server_name}-${var.env}"
  resource_group_name       = module.resource_group.rg_name
  location                  = module.resource_group.rg_location
  sql_database_collation    = local.sqldb[var.env].sql_database_collation
  sql_server_version        = local.sqlserver.sql_server_version
  sql_server_admin_username = var.sql_server_username
  sql_server_admin_password = var.sql_server_password
  sql_database_sku_name     = local.sqldb[var.env].sql_database_sku_name
  database_list             = local.sqlserver.databases
  tags                      = local.tags
}

module "azure_function" {
  source                     = "./modules/function-app"
  function_list              = local.azure_function_list
  resource_group_name        = module.resource_group.rg_name
  resource_group_location    = module.resource_group.rg_location
  storage_name               = module.storage.storagename
  storage_account_access_key = module.storage.accesskey
  app_service_plan_id        = module.app_service_plan.appserviceplanid
  identity_type              = "UserAssigned"
  tags                       = local.tags
  https_only                 = true
}

module "redis_cache" {
  source               = "./modules/radis-cache"
  redis_cache_name     = local.redis_cache[var.env].name
  resource_group_name  = module.resource_group.rg_name
  location             = module.resource_group.rg_location
  redis_cache_family   = local.redis_cache[var.env].family
  redis_cache_sku_name = local.redis_cache[var.env].sku
  tags                 = local.tags
}

module "app-insights" {
  source              = "./modules/application-insights"
  app_insights_name   = "${local.app_insights_name}-${var.env}"
  resource_group_name = module.resource_group.rg_name
  location            = module.resource_group.rg_location
  tags                = local.tags
}