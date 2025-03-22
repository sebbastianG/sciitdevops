# security.tf

resource "azurerm_network_security_group" "weather_app_nsg" {
  name                = "weather-app-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

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

  depends_on = [azurerm_resource_group.main]
}

resource "azurerm_network_interface_security_group_association" "weather_app_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.main.id   
  network_security_group_id = azurerm_network_security_group.weather_app_nsg.id

  depends_on = [azurerm_network_interface.main, azurerm_network_security_group.weather_app_nsg]
}
