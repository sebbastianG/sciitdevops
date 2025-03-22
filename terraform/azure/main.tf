###########################
# main.tf
###########################

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_group_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                                          = "${var.resource_group_name}-subnet"
  resource_group_name                           = azurerm_resource_group.main.name
  virtual_network_name                          = azurerm_virtual_network.main.name
  address_prefixes                              = ["10.0.1.0/24"]
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  default_outbound_access_enabled               = true
}

resource "azurerm_public_ip" "k3s" {
  name                    = "${var.resource_group_name}-k3s-public-ip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  sku_tier                = "Regional"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

resource "azurerm_public_ip" "observability" {
  name                    = "${var.resource_group_name}-observability-public-ip"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  sku_tier                = "Regional"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

resource "azurerm_network_interface" "k3s" {
  name                = "${var.resource_group_name}-k3s-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k3s.id
  }
}

resource "azurerm_network_interface" "observability" {
  name                = "${var.resource_group_name}-observability-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.observability.id
  }
}

resource "azurerm_linux_virtual_machine" "k3s" {
  name                = "${var.resource_group_name}-k3s-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = var.vm_admin_username

  network_interface_ids = [azurerm_network_interface.k3s.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.resource_group_name}-k3s-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    role = "k3s"
  }
}

resource "azurerm_linux_virtual_machine" "observability" {
  name                = "${var.resource_group_name}-observability-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s"
  admin_username      = var.vm_admin_username

  network_interface_ids = [azurerm_network_interface.observability.id]

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.resource_group_name}-observability-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    role = "observability"
  }
}
