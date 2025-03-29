
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "azure-vm"
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = "Standard_B1s"

  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  custom_data = base64encode(<<EOF
#cloud-config
ssh_pwauth: true
users:
  - name: ${var.vm_admin_username}
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
    passwd: ${var.vm_admin_password}
EOF
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "azure-vm-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }
}
