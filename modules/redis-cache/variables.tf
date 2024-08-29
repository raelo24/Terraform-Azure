variable "location" {
  description = "Location of this resource."
}

variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "redis_cache_name" {
  type        = string
  description = "redis cache name"
}

variable "redis_cache_sku_name" {
  type        = string
  description = "Basic,Standard,Premium"
}

variable "redis_cache_family" {
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}


