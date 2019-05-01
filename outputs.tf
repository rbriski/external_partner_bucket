output "bucket_name" {
    description = "Bucket name"
    value = ["${aws_s3_bucket.loom.id}"]
}

output "full_access_key" {
  description = "Access key for full access account"
  value       = ["${aws_iam_access_key.loom.id}"]
}

output "full_access_secret" {
  description = "Secret key for full access account"
  value       = ["${aws_iam_access_key.loom.secret}"]
}

output "write_access_key" {
  description = "Access key for write (external) access account"
  value       = ["${aws_iam_access_key.loom-external.id}"]
}

output "write_access_secret" {
  description = "Secret key for write (external) access account"
  value       = ["${aws_iam_access_key.loom-external.secret}"]
}