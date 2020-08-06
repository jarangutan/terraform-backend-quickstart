locals {
  define_lifecyle_rule = var.noncurrent_version_expiration != null
}

#### KMS Key
resource "aws_kms_key" "state_key" {
  description             = "s3 state encrypt key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

#### S3 bucket
resource "aws_s3_bucket" "state" {
  bucket        = "${var.prefix}-terraform-state"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  dynamic "lifecycle_rule" {
    for_each = local.define_lifecyle_rule ? [true] : []
    content {
      enabled = true
      dynamic "noncurrent_version_expiration" {
        for_each = var.noncurrent_version_expiration != null ? [var.noncurrent_version_expiration] : []
        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
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
