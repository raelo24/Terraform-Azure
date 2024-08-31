output "managed_identity_id" {
  value = azurerm_user_assigned_identity.agw_user_identity.id
  description = "Id of the managed idenity"
}

output "subnet_id" {
    value = azurerm_subnet.subnet.id
    description = "Id of the subnet"  
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
  description = "Id of the vnet"  
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
  description = "Name of the virtual network"  
}