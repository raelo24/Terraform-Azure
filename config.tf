locals {
  org          = "cloudsetup"
  domain       = "mydomain.com"
  secrets_name = ["first-kv-secret"]

  apis = ["backend-api"]

  service_plan = {
    dev = {
      name = "${local.org}-${var.env}-plan"
      sku  = "B1"
      os   = "Linux"
    }
    prod = {
      name = "${local.org}-${var.env}-plan"
      sku  = "B1"
      os   = "Linux"
    }
  }

  azure_function_list = ["my-function-${var.env}", "my2-function-${var.env}", "my3-function-${var.env}"]

  sqlserverdb = {
    dev = {
      sql_server_name        = "sqlserver${var.env}"
      sql_server_version     = "12.0"
      sql_databases          = ["firstdb", "secondb"]
      sql_database_collation = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name  = "Basic"
    }
    prod = {
      sql_server_name        = "sqlserver${var.env}"
      sql_server_version     = "12.0"
      sql_databases          = ["thirddb", "fouthdb"]
      sql_database_collation = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name  = "Basic"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
    Owner       = local.org
  }

  app_insights = {
    name             = "${local.org}-appinsight-${var.env}"
    application_type = "web"
  }

  storage_containers = ["my-storage-container", "my2-storage-container"]

  redis_cache = {
    dev = {
      name     = "redis-${local.org}-${var.env}"
      family   = "C"
      sku      = "Basic"
      capacity = "0"
    }
    prod = {
      name     = "redis-${local.org}-${var.env}"
      family   = "C"
      sku      = "Standard"
      capacity = "0"
    }
  }

  servicebus = [
    {
      topic         = "notifications"
      subscriptions = ["email-subscription"] //"sms-subscription"
    },
    {
      topic         = "payment-completed"
      subscriptions = ["inventory-subcription", "logistics-subscription"]
    }
  ]

  #-application gateway config for dev and staging. More environments can be added similarly
  app_gateway = {
    dev = {
      agw_name                = "${local.org}-agw-${var.env}"
      agw_sku_tier            = "WAF_v2"
      agw_sku_name            = "WAF_v2"
      agw_identity_type       = "UserAssigned"
      agw_min_capacity        = 1
      agw_max_capacity        = 2
      vnet_address_space      = ["10.0.0.0/16"]
      subnet_address_prefixes = ["10.0.1.0/24"]
      probe_path              = "/health"
      path_rules              = ["/backend/*"]
      enable_waf              = true
    }
    prod = {
      agw_name                = "${local.org}-agw-${var.env}"
      agw_sku_tier            = "WAF_v2"
      agw_sku_name            = "WAF_v2"
      agw_identity_type       = "UserAssigned"
      agw_min_capacity        = 1
      agw_max_capacity        = 2
      vnet_address_space      = ["10.0.0.0/16"]
      subnet_address_prefixes = ["10.0.1.0/24"]
      probe_path              = "/health"
      path_rules              = ["/backend/*"]
      enable_waf              = true
    }
  }

  keyvault = {
    name = "kv-${local.org}-${var.env}-admin" # must be globally unique
    secrets = {
      "db-password" = var.sql_server_password
      "api-key"     = ""
      "jwt-secret"  = ""
    }
  }
}
