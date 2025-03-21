# Create Resource Group for the Weather App
resource "azurerm_resource_group" "weather_app_rg" {
  name     = var.weather_app_resource_group_name
  location = var.weather_app_resource_group_location
}

# Create Virtual Network
resource "azurerm_virtual_network" "my_vnet" {
  name                = "weather-app-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.weather_app_rg.location
  resource_group_name = azurerm_resource_group.weather_app_rg.name
}

# Create Subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "weather-app-subnet"
  resource_group_name  = azurerm_resource_group.weather_app_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Public IP
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "weather-app-public-ip"
  resource_group_name = azurerm_resource_group.weather_app_rg.name
  location            = azurerm_resource_group.weather_app_rg.location
  allocation_method   = "Dynamic"
}

# Create Virtual Machine for K3s
resource "azurerm_linux_virtual_machine" "k3s_vm" {
  name                  = "k3svm"
  location              = azurerm_resource_group.weather_app_rg.location
  resource_group_name   = azurerm_resource_group.weather_app_rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
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

# Create Virtual Machine for Observability
resource "azurerm_linux_virtual_machine" "observability_vm" {
  name                  = "observabilityvm"
  location              = azurerm_resource_group.weather_app_rg.location
  resource_group_name   = azurerm_resource_group.weather_app_rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
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
