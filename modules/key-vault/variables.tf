variable "resource_group_name" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "kv_name" {
  type        = string
  description = "The name of the Azure Key Vault"
}

variable "sku_name" {
  type        = string
  description = "Select Standard or Premium SKU"
}

variable "Keyvault_secrets" {
  type        = map(string)
  description = "keys for secrets to be created"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}
