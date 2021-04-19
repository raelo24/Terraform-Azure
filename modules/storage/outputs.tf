output "storagename" {
    value =  azurerm_storage_account.storage_account.name  
    description = "the storage name"
}

output "accesskey" {
    value = azurerm_storage_account.storage_account.primary_access_key
    description = "The primary access key"  
}

output "blobconnectionstring" {
    value = azurerm_storage_account.storage_account.primary_blob_connection_string 
    description = "Connection string to blob storage" 
}