variable "resource_group_location" {
  default     = "westus2"
  description = "Location of the resource group."
}

variable "resource_group_base_name" {
  default     = "rg-cloudsetup"
  description = "Name of the resource group."
}

variable "env" {
  type        = string
  description = "Environment being used"
  default     = "dev"
}

variable "servicebus-sku" {
  type        = string
  default     = "Standard"
  description = "Select Basic,Standard or Premium SKU" #Basic will not allow some operations on Topic 
}

variable "sql_server_username" {
  type        = string
  description = "The server username"
}

variable "storage-account-tier" {
  type        = string
  description = "storage account tier"
  default     = "Standard"
}

variable "sql_server_password" {
  type = string
}

variable "storage-acc-replication-type" {
  type        = string
  description = "storage account replication type [LRS ZRS GRS RAGRS GZRS RAGZRS]"
  default     = "LRS"
}
