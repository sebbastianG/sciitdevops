variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure Client ID"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Client Secret"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "resource_group_location" {
  type        = string
  description = "Azure region where the resource group is created"
  default     = "Central India"  # Set default to avoid errors
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "terraform-rg"  # Set default to avoid errors
}

variable "vm_admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "sebastian"  # Set default username
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key for VM login"
}
