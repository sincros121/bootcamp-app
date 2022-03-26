


resource "azurerm_subnet" "public" {
  name                 = "public"
  resource_group_name  = var.rg-name
  virtual_network_name = var.vnet-name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "private"
  resource_group_name  = var.rg-name
  virtual_network_name = var.vnet-name
  address_prefixes     = ["10.0.2.0/24"]

  delegation {
    name = "database-subnet-delegation"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


resource "azurerm_subnet_network_security_group_association" "associate-public-SCG" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = var.public-scg-id
}

resource "azurerm_subnet_network_security_group_association" "associate-private-SCG" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = var.private-scg-id

}