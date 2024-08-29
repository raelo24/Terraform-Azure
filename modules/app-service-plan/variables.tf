variable "app_service_plan_name" {
  type        = string
  description = "name of the app service plan"
}

variable "sku" {
  type        = string
  description = "Size of the service plan"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}

variable "os_type" {
  type = string
  default = "Linux"
  description = "The os type for this service plan"  
}
