output "keyvaultid" {
  value       = azurerm_key_vault.key_vault.id
  description = "Id of the key vault"
}

output "secrets" {
  value     = azurerm_key_vault_secret.Keyvault_secret
  sensitive = true
}
