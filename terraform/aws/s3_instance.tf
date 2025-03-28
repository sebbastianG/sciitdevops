resource "aws_s3_bucket" "jefrijeronimo" {
  bucket = "${var.bucket_name}-${replace(timestamp(), ":", "-")}"

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}
