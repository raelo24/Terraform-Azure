resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_storage_container" "storage_container" {
  for_each              = toset(var.container_list)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "blob"
}
