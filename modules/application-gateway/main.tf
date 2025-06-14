# -
# - Configuration file for Application gateway. 
# - This can be configured to meet custom specific needs and cost considerations
# - Consideration is given if you decide to use WAF_v2 for which polocies can be set

# App Gateway public IP
resource "azurerm_public_ip" "public_agw_ip" {
  name                = local.public_agw_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.agw_sku_tier == "WAF_v2" ? "Static" : "Dynamic"
  sku                 = var.agw_sku_tier == "WAF_v2" ? "Standard" : "Basic"
  domain_name_label   = var.agw_name
  tags                = var.tags
}

# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.agw_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes
}

locals {
  public_agw_ip_name       = "${var.agw_name}-public-ip"
  http_listener_name       = "${var.agw_name}-listener"
  gateway_ip_configuration = "${var.agw_name}-configuration"
  routing_rule_name        = "${var.agw_name}-routing-rule"
}

# App Gateway workspace
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.agw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.analytics_sku
  retention_in_days   = 730
  tags                = var.tags
}

# Managed service Identity
resource "azurerm_user_assigned_identity" "agw_user_identity" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = "${var.agw_name}-msi"
}

# Create the Applicaiton gateway
resource "azurerm_application_gateway" "agw" {
  name                = var.agw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # start the configurations/settings of the gateway 
  sku {
    name     = var.agw_sku_name
    tier     = var.agw_sku_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_configuration
    subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type         = var.identity_type
    identity_ids = [azurerm_user_assigned_identity.agw_user_identity.id]
  }

  waf_configuration {
    enabled          = var.enable_waf
    firewall_mode    = var.firewall_mode
    rule_set_type    = "OWASP"
    rule_set_version = "3.0"
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_name
    public_ip_address_id = azurerm_public_ip.public_agw_ip.id
  }

  # Listener for HTTP Port 80. Change to Https for 
  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = var.frontend_ip_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  backend_address_pool {
    name = var.backend_address_pool
  }

  # Change same for https with corresponding values
  probe {
    name                                      = var.custom_probe_name
    protocol                                  = "Http"
    path                                      = var.custom_probe_path
    interval                                  = "60"
    timeout                                   = "60"
    unhealthy_threshold                       = "3"
    pick_host_name_from_backend_http_settings = true
  }

  #Repeat same for https with corresponding values
  backend_http_settings {
    name                                = var.backend_http_settings
    cookie_based_affinity               = "Disabled"
    port                                = 80
    protocol                            = "Http"
    pick_host_name_from_backend_address = true
    probe_name                          = var.custom_probe_name
    path                                = "/"
    request_timeout                     = 60
  }

  request_routing_rule {
    name               = local.routing_rule_name
    rule_type          = var.routing_rule_type
    http_listener_name = local.http_listener_name
    url_path_map_name  = var.url_path_name
    priority           = 10
  }

  url_path_map {
    name                               = var.url_path_name
    default_backend_http_settings_name = var.backend_http_settings
    default_backend_address_pool_name  = var.backend_address_pool
    path_rule {
      name                       = local.routing_rule_name
      backend_address_pool_name  = var.backend_address_pool
      backend_http_settings_name = var.backend_http_settings
      paths                      = var.path_rules
    }
  }
}
