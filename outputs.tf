output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.s3.id
}

output "bucket_arn" {
  description = "The arn of the bucket"
  value       = aws_s3_bucket.s3.arn
}
