output "k3s_public_ip" {
  description = "Public IP of the k3s instance"
  value       = aws_instance.k3s.public_ip
}

output "monitoring_public_ip" {
  description = "Public IP of the monitoring instance"
  value       = aws_instance.monitoring.public_ip
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.jefrijeronimo.bucket
}

output "private_key_pem" {
  description = "Private key for SSH access"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}
