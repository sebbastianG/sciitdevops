# security.tf
resource "azurerm_network_security_group" "weather_app_nsg" {
  name                = "${var.resource_group_name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_resource_group.main]

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "weather_app_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.weather_app_nsg.id
}
