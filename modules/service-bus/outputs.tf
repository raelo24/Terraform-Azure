output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.servicebus.name
}

output "connection_string" {
  value = azurerm_servicebus_namespace.servicebus.default_primary_connection_string
}