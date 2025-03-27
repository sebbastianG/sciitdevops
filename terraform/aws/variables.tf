# terraform/aws/variables.tf

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
  description = "S3 bucket name"
  type        = string
}

variable "resource_group_name" {
  description = "Name used for prefixing AWS resources"
  type        = string
}

variable "vm_admin_username" {
  description = "EC2 instance SSH username"
  type        = string
}

variable "ssh_public_key" {
  description = "Public key for EC2 instance access"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
