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
  description = "AWS region (e.g., eu-central-1)"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "resource_group_name" {
  description = "Prefix for naming AWS resources"
  type        = string
}

variable "vm_admin_username" {
  description = "Username for EC2 SSH access"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key for remote-exec connection"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 Key Pair created in AWS"
  type        = string
}
