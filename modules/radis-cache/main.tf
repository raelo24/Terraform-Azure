resource "azurerm_redis_cache" "redis_cache" {
  name                = var.redis_cache_name
  location            = var.location
  sku_name            = var.redis_cache_sku_name
  resource_group_name = var.resource_group_name
  capacity            = 2
  family              = var.redis_cache_family
  tags                = var.tags
}
