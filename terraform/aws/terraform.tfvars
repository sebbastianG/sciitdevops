aws_access_key_id     = "your-access-key-id"
aws_secret_access_key = "your-secret-access-key"
aws_default_region    = "eu-central-1"

bucket_name           = "your-unique-bucket-name-123456"

resource_group_name   = "weather-app"
vm_admin_username     = "sebastian"
vm_admin_password     = "Seb123!@#"
key_name              = "generated-key"

# Replace this with a real public key if you want to inject one manually,
# but leave it empty here for generated key scenario.
ssh_public_key = file("${path.module}/generated-key.pub")
