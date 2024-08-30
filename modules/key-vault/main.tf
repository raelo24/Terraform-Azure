data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                      = var.kv_name
  location                  = var.resource_group_location
  sku_name                  = var.sku_name
  resource_group_name       = var.resource_group_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  tags                      = var.tags
  enable_rbac_authorization = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "1657f329-feca-4157-bab8-1794d7746eeb" //data.azurerm_client_config.current.object_id

    #set the default permission for the secrets contained in this key vault
    secret_permissions = [
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover",
      "Restore",
      "Set",
      "Backup"
    ]

    #set default key permissions for key vault. These are admin permissions
    key_permissions = [
      "Backup",
      "Create",
      "Get",
      "Update",
      "Import",
      "List",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Sign",
      "UnwrapKey",
      "Purge",
      "Recover",
      "Restore",
      "WrapKey",
      "Verify"
    ]
  }
}

# The secrets of the key vault
resource "azurerm_key_vault_secret" "Keyvault_secret" {
  for_each     = tomap(var.Keyvault_secrets)
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault.key_vault]
}
