# AWS Credentials
aws_access_key_id     = "your-access-key-id"
aws_secret_access_key = "your-secret-access-key"
aws_default_region    = "eu-central-1" # e.g. Frankfurt

# S3 Bucket Configuration
bucket_name           = "my-terraform-bucket-victor123"

# General Settings
resource_group_name   = "weather-app"

# EC2 Instance Configuration
vm_admin_username     = "sebastian"
key_name              = "sebastian"

# SSH Keys
ssh_public_key        = "ssh-rsa AAAAB3...your-public-key... user@host"
ssh_private_key_path  = "/home/runner/.ssh/sebastian.pem"
# If running locally, use:
# ssh_private_key_path = "~/.ssh/sebastian.pem"
