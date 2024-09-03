variable "location" {
  type        = string
  description = "This is used to prefix each function along with some random string to get unique values for each"
}

variable "resource_group_name" {
  type        = string
  description = "Resouce group"
}

variable "analytics_sku" {
  type        = string
  description = "The analystics workspace sku"
}

variable "data_retention_days" {
    type = string
    description = "Days to retain data"  
}

variable "workspace_name" {
  type = string
  description = "Name of the workspace"
}

variable "tags" {
    type = map
    description = "Tags associated with this workspace"
}