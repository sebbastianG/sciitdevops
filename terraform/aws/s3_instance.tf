
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "jefrijeronimo" {
  bucket = "your-unique-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = "MyS3Bucket"
  }
}
