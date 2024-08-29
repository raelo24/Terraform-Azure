variable "location" {
  description = "Location of this resource."
}

variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "app_insights_name" {
  type        = string
  description = "app insights name"
}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}

variable "application_type" {
  type        = string
  description = "Specifies the type of Application Insights to create"
}
