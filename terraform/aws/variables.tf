variable "aws_access_key_id" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS secret key"
  sensitive   = true
}

variable "aws_default_region" {
  type        = string
  description = "AWS region"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
}

variable "resource_group_name" {
  type        = string
  description = "Prefix name for AWS resources"
}

variable "vm_admin_username" {
  type        = string
  description = "EC2 instance login username"
}

variable "vm_admin_password" {
  type        = string
  description = "Password for admin user"
  sensitive   = true
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
}
