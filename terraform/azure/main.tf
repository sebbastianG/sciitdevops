data "azurerm_resource_group" "weather_app_rg" {
  name = var.weather_app_resource_group_name
}

resource "azurerm_virtual_network" "weather_app_vnet" {
  name                = "weather-app-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.weather_app_rg.location
  resource_group_name = azurerm_resource_group.weather_app_rg.name
}

resource "azurerm_subnet" "weather_app_subnet" {
  name                 = "weather-app-subnet"
  resource_group_name  = azurerm_resource_group.weather_app_rg.name
  virtual_network_name = azurerm_virtual_network.weather_app_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "weather_app_public_ip" {
  name                = "weather-app-public-ip"
  resource_group_name = azurerm_resource_group.weather_app_rg.name
  location            = azurerm_resource_group.weather_app_rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "weather_app_nic" {
  name                = "weather-app-nic"
  location            = azurerm_resource_group.weather_app_rg.location
  resource_group_name = azurerm_resource_group.weather_app_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.weather_app_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.weather_app_public_ip.id
  }
}
