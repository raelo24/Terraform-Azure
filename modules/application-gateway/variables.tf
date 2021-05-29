variable "location" {
  type        = string
  description = "This is used to prefix each function along with some random string to get unique values for each"
}

variable "resource_group_name" {
  type        = string
  description = ""
}

variable "backend_address_pool" {
  type = string
  default = "backend_address_pool"
  description = "Backend address pool"
}

variable "backend_http_settings" {
  type = string
  default = "backend_http_settings"
  description = "Backend setting name"
}
variable "agw_name" {
  type        = string
  description = "application gateway name"
}

variable "agw_sku_name" {
  type        = string
  default = "WAF_v2" # Default since waf_configuration is being set up
  description = "Choose one of Standard_Small,Standard_Medium,Standard_Large,Standard_v2,WAF_Medium,WAF_Large, and WAF_v2 etc"
}

variable "agw_sku_tier" {
  type        = string
  description = "Choose one of Standard, Standard_v2, WAF and WAF_v2 etc"
}

variable "identity_type" {
  type        = string
  description = "The idenity type."
  default     = "UserAssigned"
}

variable "min_capacity" {
  type        = string
  description = "0 to 100"
}

variable "max_capacity" {
  type        = string
  description = "2 to 125"
}

variable "public_agw_ip_name" {
  type        = string
  description = "public ip name for app gateway"
}

variable "gateway_ip_configuration" {
  type        = string
  description = "gateway ip configuration"
  default = "gateway_ip_configuration"
}

variable "frontend_port_name" {
  type        = string
  description = "Protocol name for Http or Https"
  default = "frontend_port"
}

variable "frontend_ip_name" {
  type        = string
  description = "Application gateway ip name"
  default = "frontend_ip"
}

variable "backend_configs" {
  type        = list(string)
  description = "Backend Configs"
}

variable "backend_fqdns" {
  type        = map(any)
  description = "backend FQDNS"
}

variable "http_listener_name" {
  type        = string
  description = "http listener name"
}

variable "routing_rule_name" {
  type        = string
  description = "agw routing rule name"
}

variable "address_space" {
  type        = list(string)
  description = "application virtual network address space"
}

variable "backend_config" {
  type        = list(string)
  description = "Backend config"
}

variable "address_prefixes" {
  type        = list(string)
  description = "Address prefixes"

}

variable "tags" {
  type        = map(any)
  description = "Tags for resources"
}

variable "path_rules" {
  type        = list(string)
  description = "Gateway path rules"
}

variable "url_path_name" {
  type        = string
  description = "The path name for the app URL"
}

variable "custom_probe_name" {
  type        = string
  description = "health probe name"
}

variable "custom_probe_path" {
  type        = string
  description = "health probe path"
}
