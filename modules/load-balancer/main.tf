








resource "azurerm_lb" "front-load-balancer" {
  name                = "front-load-balancer"
  location            = var.def-location
  resource_group_name = var.rg-name
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "front-lb-ip-config"
    public_ip_address_id = var.public-ip-id
    subnet_id = var.public-subnet-id

  }
}

resource "azurerm_lb_nat_rule" "example" {
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}
