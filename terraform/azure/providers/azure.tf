# Configure Terraform to use the AzureRM provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # Lock to a suitable version (example)
    }
  }
}

# AzureRM provider configuration (using variables for sensitive values)
provider "azurerm" {
  features {}  # Required empty block for Azure provider defaults

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}
