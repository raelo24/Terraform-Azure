# Introduction #
This is a sample kickstart project for configuring infrastructure on Azure. It is modularized and adding more child services for any particular resource is a parameter setting. Feel free to use and contribute to the project by adding modules for mmore Azure resources.

## Description ##
The following Azure resources are configured.

1. Resource Group
2. API Service Plan
3. Virtual Network
4. Subnets
5. App Service
6. Application Gateway
7. Application Insight
8. Azure Function Apps
9. Radis Cache
10. SQL Database
11. Storage

## Usage ##
The config.tf serves as the file to set most account-specific details for the cloud. The values therein are referenced as
```
local.xxxx
```
### Service Plan ###
The service plan is created with a module with properties like os type, sku name. One service plan is created per environment.

```
module "service_plan" {
  source                  = "./modules/app-service-plan"
  app_service_plan_name       = local.service_plan[var.env].name
  sku                     = local.service_plan[var.env].sku
  resource_group_location = module.resource_group.rg_location
  resource_group_name     = module.resource_group.rg_name
  tags                    = local.tags
  os_type                 = local.service_plan[var.env].os
}

```
The required properties are be specified in config.tf as shown below. The properties are selected depending on the enviroment. This can be updated based on your use cases.
```
service_plan = {
    "dev" = {
      name = "${local.org}-${var.env}-plan"
      sku  = "B1"
      os   = "Linux"
    }
    "prod" = {
      name = "${local.org}-${var.env}-plan"
      sku  = "B1"
      os   = "Linux"
    }
  }
```
The following parameters have configuration options
| Name | Options |  Default |
|------|-------------|:--------:|
|OS type| Windows, Linux, WindowsContainer | Linux |
|SKU | B1, B2, B3, D1, F1, I1, I2, I3,...I4mv2, I5v2, I5mv2, I6v2, P1v2, P2v2, P3| B1 |

### Storage ###
The storage module creates a storage account, a blob storage and several containers.

```
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
```
The <a href="#service-plan">service plan</a> is used. Then the list of containers to create is specified in the config. Container name can be added or removed from the list and terraform will update the resources accordingly.

```
storage_containers = ["my-storage-container", "my2-storage-container"] 
```
The parameter options can be defined as follows
| Name | Options |  Default |
|------|-------------|:--------:|
|Replication type| LRS, ZRS, GRS, RAGRS, GZRS, RAGZRS | LRS |
|Account type | Standard, Premium| Standard |

### SQL Database ###
This module first creates SQL Server for the corresponding environment, and then creates each of the databases specified in the config file. 

```
module "sql_server_db" {
  source                    = "./modules/sql-server-db"
  sql_server_name           = "${local.org}-${local.sqlserverdb[var.env].sql_server_name}-${var.env}"
  resource_group_name       = module.resource_group.rg_name
  location                  = module.resource_group.rg_location
  sql_database_collation    = local.sqlserverdb[var.env].sql_database_collation
  sql_server_version        = local.sqlserverdb[var.env].sql_server_version
  sql_server_admin_username = var.sql_server_username
  sql_server_admin_password = var.sql_server_password
  sql_database_sku_name     = local.sqlserverdb[var.env].sql_database_sku_name
  database_list             = local.sqlserverdb[var.env].databases
  tags                      = local.tags
}
```
The config file section is shown below. 
```
sqlserverdb = {
    "dev" = {
      sql_server_version        = "12.0"
      sql_databases             = ["firstdb", "secondb"]
      sql_database_collation    = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name     = "Basic"
    }
    "prod" = {
      sql_server_version        = "12.0"
      sql_databases             = ["thirddb", "fouthdb"]
      sql_database_collation    = "SQL_Latin1_General_CP1_CI_AS"
      sql_database_sku_name     = "Basic"
    }
  }

```

### Function Apps ###
This module creates several functions apps specified in a the config file
```
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

````

The list of function apps to create are specified below. Note that updating this list will add or remove function apps from the cloud account.
```
  azure_function_list =   ["my-function-${var.env}", "my-function2-${var.env}", "my-function3-${var.env}"]
```
### Application Gateway ###
This module provisions the one application gateway per environment. The configuration is defined below.

```
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
    },
    //more environments can follow
}
```
The app gateway module also provisions a number of services connected to the application gateway such as public IP address, virtual network, subnet, analytics workspace, managed identity, WAF. 

The parameter options can be defined as follows
| Name | Options |  Default |
|------|-------------|:--------:|
|AGW SKU Tier | Standard, Standard_v2, WAF and WAF_v2 | Standard |
|AGW SKU Name | Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2| WAF_v2 |

### Redis Cache ###
One Redis cache is created per environment. 
```
module "redis_cache" {
  source               = "./modules/redis-cache"
  redis_cache_name     = local.redis_cache[var.env].name
  resource_group_name  = module.resource_group.rg_name
  location             = module.resource_group.rg_location
  redis_cache_family   = local.redis_cache[var.env].family
  redis_cache_sku_name = local.redis_cache[var.env].sku
  tags                 = local.tags
}
```

The configuration is specified as
```
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
```
The options for the various parameters are defined as
| Name | Options |  Default |
|------|-------------|:--------:|
|Family | 'C' for Basic/Standard, and 'P' for Premium | C |
|SKU | Basic, Standard and Premium | Basic |
|Capacity | 0, 1, 2, 3, 4, 5, 6 for C and 1, 2, 3, 4, 5 for P | 0 |
