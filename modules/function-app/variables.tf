variable "resource_group_name" {
  type        = string
  description = "This is used to prefix each function along with some random string to get unique values for each"
}

variable "resource_group_location" {
  type        = string
  description = "Location of resource group"
}

variable "function_list" {
  type        = list(string)
  description = "List of function to create"
}

variable "storage_account_access_key" {
  type        = string
  description = "Access key of the storage account"
}

variable "storage_name" {
  type        = string
  description = "Storage name for the function app"
}

variable "service_plan_id" {
  type        = string
  description = "App service plan id being used"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}

variable "app_insights_connectionstring" {
  type        = string
  description = "Connection string of app insight"
}

variable "app_insights_key" {
  type        = string
  description = "Application insights Instrumentation Key"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "storage_connection_string" {
  type = string
  description = "Storage account connection string"
}

variable "service_bus_connection_string" {
  type = string
  description = "The connection string of the service bus"
}