

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet-name
  location            = var.location
  resource_group_name = var.rg-name
  address_space       = ["10.0.0.0/22"]

  subnet {
    name           = var.public-subnet-name
    address_prefix = "10.0.1.0/24"
    security_group = var.public-scg

  }

  subnet {
    name           = var.private-subnet-name
    address_prefix = "10.0.2.0/24"
    security_group = var.private-scg
  }
}