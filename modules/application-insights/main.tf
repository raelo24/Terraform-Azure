resource "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  application_type    = var.application_type
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
