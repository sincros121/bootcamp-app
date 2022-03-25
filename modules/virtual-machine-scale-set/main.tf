
resource "azurerm_linux_virtual_machine_scale_set" "web-application-VM-scale-set" {
  name                = "web-application-VM-scale-set"
  resource_group_name = var.rg-name
  location            = var.location
  sku                 = "Standard_F2"
  instances           = 3
  admin_username      = "ubuntu"
  admin_password = var.VM-password
  disable_password_authentication = false
  custom_data = var.VM-custom-data


  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "StandardSSD_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.internal.id
    }
  }
}