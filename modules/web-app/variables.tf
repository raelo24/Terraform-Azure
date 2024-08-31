variable "location" {
  type        = string
  description = "Location of this resource"
}

variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "service_plan_id" {
  type        = string
  description = "Service plan Id"
}

variable "keyvault_id" {
  type        = string
  description = "Key vault"
}

variable "environment" {
  type        = string
  description = "The environment is use"
}

variable "vnet_route_all_enabled" {
  type        = bool
  default = true
  description = "Whether all outbound traffic should all have VNSG or User Defined Route"
}

variable "swift_subnet_prefixes" {
  type        = list(string)
  description = "subnet prefixes for VNET integration for the web application"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "services" {
  type = list(object({
    path    = string
    api     = string
    db_name = string
  }))
  description = "List of app services and corresponding db"
}

variable "sql_server_name" {
  type        = string
  description = "Name given to sql servr"
}

variable "sql_server_username" {
  type        = string
  description = "Login username of SQL server"
}

variable "redis_cache_connection" {
  type        = string
  description = "Redis cache connection string"
}

variable "websockets_enabled" {
  type        = bool
  description = "Whether web sockets should be enabled"
}

variable "appinsight_key" {
  type        = string
  description = "Instrumentation key of application insight"
}

variable "appinsight_connection" {
  type        = string
  description = "Application insight connection string"
}

variable "storage_account_access_key" {
  type        = string
  description = "Access key of storage account"
}

variable "service_bus_connection" {
  type        = string
  description = "Connection string of service bus"
}

variable "managed_identity_id" {
  type        = string
  description = "Id of the managed identity"
}

