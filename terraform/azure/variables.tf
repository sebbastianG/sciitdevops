# -------------------------
# variables.tf
# -------------------------
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the Azure resource group"
  type        = string
}

variable "vm_admin_username" {
  description = "VM administrator username"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH Public Key for VM login"
  type        = string
}






variable "vm_admin_password" {
  type        = string
  description = "Admin password for the VM"
  sensitive   = true
}
