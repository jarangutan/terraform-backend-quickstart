#### KMS Key
resource "aws_kms_key" "state_key" {
  description             = "s3 state encrypt key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

#### S3 bucket
resource "aws_s3_bucket" "state" {
  bucket_prefix = var.prefix
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.state_key.arn
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}