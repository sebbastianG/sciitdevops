resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = "ExampleBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "example_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
}
