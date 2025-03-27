# terraform/aws/s3_instance.tf

resource "random_string" "rand" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "example" {
  bucket = "${var.bucket_name}-${random_string.rand.result}"

  tags = {
    Name        = "my-terraform-bucket-${random_string.rand.result}"
    Environment = "Dev"
  }
}
