variable "resource_group_name" {
  type        = string
  description = "This name is prepended to the reource and combined with random string for uniqueness"
}

variable "location" {
  type        = string
  description = "Location of this resource"
}

variable "servicebus_sku" {
  type        = string
  description = "The desired sku"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}

variable "servicebus_name" {
  type        = string
  description = "The service bus name"
}
