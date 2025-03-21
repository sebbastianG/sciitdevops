resource "azurerm_resource_group" "weather_app_rg" {
  name     = var.weather_app_resource_group_name
  location = var.weather_app_resource_group_location
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

resource "azurerm_linux_virtual_machine" "k3s_vm" {
  name                  = "k3svm"
  location              = azurerm_resource_group.weather_app_rg.location
  resource_group_name   = azurerm_resource_group.weather_app_rg.name
  network_interface_ids = [azurerm_network_interface.weather_app_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "k3svm"
  admin_username = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.ssh_public_key
  }
}

resource "azurerm_linux_virtual_machine" "observability_vm" {
  name                  = "observabilityvm"
  location              = azurerm_resource_group.weather_app_rg.location
  resource_group_name   = azurerm_resource_group.weather_app_rg.name
  network_interface_ids = [azurerm_network_interface.weather_app_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "observabilityvm"
  admin_username = var.vm_admin_username

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.ssh_public_key
  }
}
