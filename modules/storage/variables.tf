variable "resource_group_name" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "storage_name" {
  type        = string
  description = "storage name"

}

variable "storage_account_tier" {
  type        = string
  description = "storage account tier"
  default = "Standard"

}

variable "container_list" {
  type = list(string)
  description = "The list of containers to create"
}
variable "storage_replication_type" {
  type        = string
  description = "storage account replication type"
  default = "LRS"

}

variable "logs" {
  default     = "apps-log"
  description = "app-log"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}
