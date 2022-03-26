output "public-ip" {
  value = azurerm_public_ip.load-balancer-public-ip.ip_address
}

output "VM-password" {
  value     = module.azure-vault[0].vm-password
  sensitive = true
}
