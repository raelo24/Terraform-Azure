variable "resource_group_name" {
  default     = "rg-example"
  description = "Name of resource group"
}

variable "location" {
  default     = "westus"
  description = "Location of resource group"
}

variable "sql_server_name" {
  type        = string
  description = "SQL Server name"
}

variable "sql_server_version" {
  type        = string
  description = "SQL Server version"
}

variable "sql_server_admin_username" {
  type        = string
  description = "SQL Server admin login"
}

variable "sql_server_admin_password" {
  type        = string
  description = "SQL Server admin login password"
}

variable "sql_database_sku_name" {
  type        = string
  description = "SQL Server database sku name"
}

variable "sql_database_collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  description = "SQL Server database collation"
}
variable "database_list" {
  type        = list(string)
  description = "List of databases to be created"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}
