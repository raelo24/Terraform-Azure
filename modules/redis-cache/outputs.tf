output "connectionstring" {
  value = azurerm_redis_cache.redis_cache.primary_connection_string
}
