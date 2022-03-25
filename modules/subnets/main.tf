


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
}