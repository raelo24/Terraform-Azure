#NAT gateway public IP
resource "azurerm_public_ip" "public_nat_ip" {
  name                = "nat-gateway-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# subnet for app services to be be assoicated with NAT
resource "azurerm_subnet" "appservices_subnet" {
  name                 = "app_services_subnet"
  address_prefixes     = var.subnet_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  delegation {
    name = "serverfams"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
  subnet_id      = azurerm_subnet.appservices_subnet.id
  depends_on = [
    azurerm_subnet.appservices_subnet,
    azurerm_nat_gateway.nat_gateway
  ]
}
