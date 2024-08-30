variable "location" {
  type        = string
  description = "This is used to prefix each function along with some random string to get unique values for each"
}

variable "resource_group_name" {
  type        = string
  description = ""
}

variable "backend_address_pool" {
  type        = string
  default     = "backend_address_pool"
  description = "Backend address pool"
}

variable "backend_http_settings" {
  type        = string
  default     = "backend_http_settings"
  description = "Backend setting name"
}
variable "agw_name" {
  type        = string
  description = "application gateway name"
}

variable "agw_sku_name" {
  type        = string
  default     = "WAF_v2" # Default since waf_configuration is being set up
  description = "Choose one of Standard_Small,Standard_Medium,Standard_Large,Standard_v2,WAF_Medium,WAF_Large, and WAF_v2 etc"
}

variable "agw_sku_tier" {
  type        = string
  description = "Choose one of Standard, Standard_v2, WAF and WAF_v2 etc"
}

variable "identity_type" {
  type        = string
  description = "The idenity type"
  default     = "UserAssigned"
}

variable "firewall_mode" {
  type        = string
  default     = "Detection" # or Prevention
  description = "The firewall setting"
}

variable "frontend_port_name" {
  type        = string
  description = "Protocol name for Http or Https"
  default     = "frontend_port"
}

variable "analytics_sku" {
  type        = string
  default     = "PerGB2018"
  description = "The analystics workspace sku"
}

variable "frontend_ip_name" {
  type        = string
  description = "Application gateway ip name"
  default     = "frontend_ip"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "application virtual network address space"
}

variable "subnet_address_prefixes" {
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
  default     = "agw_path"
  description = "The path name for the app URL"
}

variable "custom_probe_name" {
  type        = string
  default     = "agw_health_probe"
  description = "health probe name"
}

variable "enable_waf" {
  type        = bool
  default     = true
  description = "Whether WAF should be enabled"
}
variable "custom_probe_path" {
  type        = string
  description = "health probe path"
}

variable "routing_rule_type" {
  type    = string
  default = "PathBasedRouting" # or Basic;  PathBasedRouting is for URL-based routing  
}
