###########################
# security.tf
###########################

resource "azurerm_network_security_group" "weather_app_nsg" {
  name                = "${var.resource_group_name}-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

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

resource "azurerm_network_interface_security_group_association" "k3s" {
  network_interface_id      = azurerm_network_interface.k3s.id
  network_security_group_id = azurerm_network_security_group.weather_app_nsg.id
}

resource "azurerm_network_interface_security_group_association" "observability" {
  network_interface_id      = azurerm_network_interface.observability.id
  network_security_group_id = azurerm_network_security_group.weather_app_nsg.id
}
