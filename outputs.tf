output "bucket" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.s3.id
}