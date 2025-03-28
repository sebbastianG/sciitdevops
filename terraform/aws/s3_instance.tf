resource "aws_s3_bucket" "sebica" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "my-terraform-bucket"
    Environment = "Dev"
  }
}
