output "backend-pool-id" {
  value = azurerm_lb_backend_address_pool.web-application-backend-pool.id
}

output "inbound-nat-rule-id" {
  value = azurerm_lb_nat_pool.lb-nat-pool.id
}