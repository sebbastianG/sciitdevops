variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}

variable "aws_default_region" {
  description = "AWS region"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "resource_group_name" {
  description = "Project or resource group name used in tags"
  type        = string
}

variable "vm_admin_username" {
  description = "Username for the EC2 VM administrator"
  type        = string
}

variable "vm_admin_password" {
  description = "Password for the EC2 VM administrator"
  type        = string
  sensitive   = true
}

variable "key_name" {
  description = "Name of the SSH key pair to create in AWS"
  type        = string
}

variable "ssh_public_key" {
  description = "Optional: SSH public key to use. If empty, a key will be generated automatically."
  type        = string
  default     = ""
}
