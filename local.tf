locals {
  org          = "cloudsetup"
  domain       = "mydomain.com"
  secrets_name = ["first-kv-secret"]

  apis = ["backend-api"]

  sqlserver = {
    sql_server_name    = "${local.org}-sql-server"
    sql_server_version = "12.0"
    databases          = ["FirstDbSample", "SecondDbSample"] #list the databases to create
  }

  app_service_plan = {
    "dev" = {
      name = "${local.org}-${var.env}-plan"
      size = "B1"
      tier = "Basic"
    }
    "prod" = {
      name = "${local.org}-${var.env}-plan"
      size = "B1"
      tier = "Basic"
    }
  }
  azure_function_list = [
    "my-function-${local.org}-${var.env}",
    "my2-function-${local.org}-${var.env}",
    "my3-function-${local.org}-${var.env}"
  ]

  sqlcatalogs = {
    "${local.apis[0]}" = "${local.sqlserver.databases[0]}"
  }


  sqldb = {
    "dev" = {
      sql_database_name         = "sql-database-${local.org}"
      sql_database_collation    = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name     = "Basic"
      sqldb_db_service_obj_name = "B1"
      sql_database_min_capacity = "0.5"
      sql_database_max_size_gb  = "2"
      sql_db_read_replica_count = "0"
      sql_db_auto_pause_delay   = "60"
    }
    "prod" = {
      sql_database_name         = "sql-database-${local.org}"
      sql_database_collation    = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name     = "Basic"
      sqldb_db_service_obj_name = "B1"
      sql_database_min_capacity = "0.5"
      sql_database_max_size_gb  = "2"
      sql_db_read_replica_count = "0"
      sql_db_auto_pause_delay   = "60"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
    Owner       = local.org
  }

  fromaddress = "help@${local.domain}" #help address

  storage_containers = ["my-storage-container", "my2-storage-container"] //"my2-storage-container"
  static_web_sites   = ["cloudsetup"]
  # - if your domain name is cloudsetup.com, you get: api.dev.cloudsetup.com (dev), api.cloudsetup.com(prod)
  # - Given that environment name for dev is env = "dev", and prod is env = ""
  # - Include more hostname depending ont he needs of your org
  static_host_names = {
    "backendapi" = "api.${var.env}.${local.domain}"
  }

  url_path_map_name = "api_path_${local.org}"
  path_rule_name    = "path_name_${local.org}"
  custom_probe_name = "agw_health_probe"
  custom_probe_path = "/health"
  app_insights_name = "app_insights_${local.org}"
  backend_configs   = ["backend"]

  backend_fqdns = {
    "backend" = "backend-cloudsetup-api-${var.env}.azurewebsites.net"
  }

  path_rules = ["/backend/*"]

  redis_cache = {
    "dev" = {
      name     = "redis-${local.org}-${var.env}"
      family   = "C"
      sku      = "Basic"
      capacity = "0"
    }
    "prod" = {
      name     = "redis-${local.org}-${var.env}"
      family   = "C"
      sku      = "Standard"
      capacity = "0"
    }
  }

  servicebus_name = "Sb${local.org}${var.env}sample"

  application_gateway = {
    "dev" = {
      agw_name          = "${local.org}-agw-${var.env}"
      agw_sku_tier      = "WAF_v2"
      agw_sku_name      = "WAF_v2"
      agw_identity_type = "UserAssigned"
      min_capacity      = 1
      max_capacity      = 2
      address_space     = ["10.0.0.0/16"]
      address_prefixes  = ["10.0.1.0/24"]
    }
    "prod" = {
      agw_name          = "${local.org}-agw-${var.env}"
      agw_sku_tier      = "WAF_v2"
      agw_sku_name      = "WAF_v2"
      agw_identity_type = "UserAssigned"
      min_capacity      = 1
      max_capacity      = 2
      address_space     = ["10.0.0.0/16"]
      address_prefixes  = ["10.0.1.0/24"]
    }
  }

  keyvault = {
    name = "kv-${local.org}-${var.env}-admin" # must be globally unique
    secrets = {
      "db-password" = var.sql_server_password
      "api-key"     = "XYZ-ABC-1234"
      "jwt-secret"  = "jwt-secret-value"
    }
  }
}
