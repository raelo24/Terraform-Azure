variable "app_service_plan_name" {
    type        = string
    description = "name of the app service plan"      
}

variable "size" {
    type        = string
    description = "Size of the app service plan"  
}

variable "tier" {
    type = string
    description = "Tier of the resource group"
}
variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}

