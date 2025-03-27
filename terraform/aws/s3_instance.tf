resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = "my-terraform-bucket-sebi123-xyz"
    Environment = "Dev"
  }
}
