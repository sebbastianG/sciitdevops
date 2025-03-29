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
  description = "Prefix for resources"
  type        = string
}

variable "vm_admin_username" {
  description = "VM username"
  type        = string
}

variable "vm_admin_password" {
  description = "VM password"
  type        = string
  sensitive   = true
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch the instance in"
  type        = string
}
