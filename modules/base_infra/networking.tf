resource "azurerm_virtual_network" "main" {
  name                = "vnet-${local.base_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = [var.vnet_range]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 8, 0)]
}

resource "azurerm_subnet" "apim" {
  name                 = "apim"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_range, 8, 1)]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "nsg-${local.base_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Associate NSG with subnets
resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_subnet_network_security_group_association" "apim" {
  subnet_id                 = azurerm_subnet.apim.id
  network_security_group_id = azurerm_network_security_group.main.id
}
