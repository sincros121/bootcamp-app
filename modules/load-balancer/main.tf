


resource "azurerm_lb" "front-load-balancer" {
  name                = "front-load-balancer"
  location            = var.def-location
  resource_group_name = var.rg-name
  sku                 = "Standard"


  frontend_ip_configuration {
    name                 = "frontend-IP-configuration"
    public_ip_address_id = var.public-ip-id

  }
}

resource "azurerm_lb_backend_address_pool" "web-application-backend-pool" {
  loadbalancer_id = azurerm_lb.front-load-balancer.id
  name            = "web-application-backend-pool"
}

resource "azurerm_lb_outbound_rule" "front-lb-outbound-rule" {
  resource_group_name     = var.rg-name
  loadbalancer_id         = azurerm_lb.front-load-balancer.id
  name                    = "front-lb-outbound-rule"
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web-application-backend-pool.id

  frontend_ip_configuration {
    name = "frontend-IP-configuration"
  }
}

resource "azurerm_lb_probe" "port-8080-hp" {
  resource_group_name = var.rg-name
  loadbalancer_id     = azurerm_lb.front-load-balancer.id
  name                = "port-8080-hp"
  port                = 8080
}

resource "azurerm_lb_rule" "lb-rule" {
  resource_group_name            = var.rg-name
  loadbalancer_id                = azurerm_lb.front-load-balancer.id
  name                           = "Port-8080-lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "frontend-IP-configuration"
  disable_outbound_snat          = true
  probe_id                       = azurerm_lb_probe.port-8080-hp.id
  backend_address_pool_ids       = var.backend-address-pool-ids
}


resource "azurerm_lb_nat_pool" "lb-nat-pool" {
  resource_group_name            = var.rg-name
  loadbalancer_id                = azurerm_lb.front-load-balancer.id
  name                           = "lb-nat-pool"
  protocol                       = "Tcp"
  frontend_port_start            = var.frontend-port-start
  frontend_port_end              = var.frontend-port-end
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend-IP-configuration"
}


