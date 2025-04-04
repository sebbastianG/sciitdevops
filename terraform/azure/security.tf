# -------------------------
# security.tf
# -------------------------
resource "azurerm_network_security_group" "weather_app_nsg" {
  name                = "${azurerm_resource_group.main.name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH"
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
