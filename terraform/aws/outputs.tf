output "s3_bucket_arn" {
  value       = aws_s3_bucket.example.arn
  description = "ARN of the S3 bucket"
}
