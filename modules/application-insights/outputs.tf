output "connection_stromg" {
  value       = azurerm_application_insights.app_insights.connection_string
  description = "App insight connection string"
}

output "instrumentation_key" {
  value       = azurerm_application_insights.app_insights.instrumentation_key
  description = "Key"
}
