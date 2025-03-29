
output "instance_public_ip" {
  value = aws_instance.vm.public_ip
}

output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}

output "s3_bucket_name" {
  value = aws_s3_bucket.jefrijeronimo.bucket
}
