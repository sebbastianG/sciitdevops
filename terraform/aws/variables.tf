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
  description = "AWS region to deploy resources in"
  type        = string
}

variable "bucket_name" {
  description = "Unique name for the S3 bucket"
  type        = string
}

variable "resource_group_name" {
  description = "Name prefix for tagging AWS resources"
  type        = string
}

variable "vm_admin_username" {
  description = "Username for SSH access to the EC2 instance"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}

variable "key_name" {
  description = "Name of the existing AWS key pair to use for EC2"
  type        = string
}
