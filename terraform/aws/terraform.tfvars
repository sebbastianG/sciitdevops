aws_access_key_id     = "your-access-key-id"
aws_secret_access_key = "your-secret-access-key"
aws_default_region    = "eu-central-1"

bucket_name           = "my-terraform-bucket-victor123"
resource_group_name   = "weather-app"

vm_admin_username     = "sebastian"
key_name              = "sebastian"

ssh_public_key        = "ssh-rsa AAAAB3...your-public-key... user@host"

# FILE: terraform/aws/variables.tf
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
