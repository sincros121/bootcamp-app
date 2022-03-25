

resource "azurerm_linux_virtual_machine" "linux-VM" {
  count                           = var.VM-amount
  admin_username                  = var.VM-username
  location                        = var.location
  name                            = "${var.VM-name}-00${count.index + 1}"
  network_interface_ids           = [var.application-NIC-id]
  resource_group_name             = var.rg-name
  size                            = "Standard_B1s"
  admin_password                  = var.admin-password
  disable_password_authentication = "false"
  custom_data = var.VM-custom-data
  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    name                 = "web-application-VM-disk-00${count.index + 1 }"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
}

