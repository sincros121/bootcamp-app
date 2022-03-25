output "public-ip" {
  value = azurerm_public_ip.load-balancer-public-ip.ip_address
}

output "VM-password" {
  value = data.azurerm_key_vault_secret.vm-password.value
  sensitive = true
}

#output "rendered-file" {
#  value = data.template_file.custom-data-shell-script.rendered
#}
