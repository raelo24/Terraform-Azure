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

variable "topic_subscriptions" {
  type = list(object({
    topic         = string
    subscriptions = list(string)
  }))
  description = "list of topics and subscriptions on each topic"
}

variable "max_size" {
  type        = number
  default     = 1024
  description = "Maximum size in MB"
}

variable "max_delivery_count" {
  type        = number
  default     = 10
  description = "Max of the delivery attempts"
}
