output "instance_id" {
  value       = aws_instance.vm.id
  description = "ID of the EC2 instance"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.example.arn
  description = "ARN of the S3 bucket"
}
