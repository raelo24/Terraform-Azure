output "rg_name" {
    value       = azurerm_resource_group.rg.name
    description = "Name of the resource group"
}

output "rg_location" {
    value       = azurerm_resource_group.rg.location  
    description = "Location of resource group"
}