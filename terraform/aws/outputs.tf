output "s3_bucket_arn" {
  value       = aws_s3_bucket.example.arn
  description = "ARN of the S3 bucket"
}

output "ec2_instance_id" {
  value       = aws_instance.vm.id
  description = "EC2 Instance ID"
}

output "ec2_public_ip" {
  value       = aws_instance.vm.public_ip
  description = "Public IP of the EC2 instance"
}
