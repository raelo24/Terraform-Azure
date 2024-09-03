#workspace
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.analytics_sku
  retention_in_days   = var.data_retention_days
  tags                = var.tags  
}
