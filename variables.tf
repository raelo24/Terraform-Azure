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
}