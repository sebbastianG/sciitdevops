output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.generated_key.private_key_pem
  sensitive   = true
}

output "instance_id" {
  value = aws_instance.vm.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.jefrijeronimo.arn
}
