output "instance_id" {
  value = aws_instance.vm.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.jefrijeronimo.arn
}
