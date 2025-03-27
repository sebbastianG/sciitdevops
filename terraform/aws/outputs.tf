# terraform/aws/outputs.tf

output "instance_id" {
  value = aws_instance.vm.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.example.arn
}

# terraform/aws/providers.tf

provider "aws" {
  region     = var.aws_default_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
