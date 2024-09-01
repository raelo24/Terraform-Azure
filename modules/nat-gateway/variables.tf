variable "location" {
  type        = string
  description = "This is used to prefix each function along with some random string to get unique values for each"
}

variable "resource_group_name" {
  type        = string
  description = "Resouce group"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "subnet prefixes for VNET integration for the web application"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}
