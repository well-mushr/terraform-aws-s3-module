resource "aws_s3_bucket" "s3" {
  bucket = var.bucket

  acl  = var.acl
  tags = var.tags

  dynamic "versioning" {
    for_each = length(var.versioning) == 0 ? [] : [var.versioning]

    content {
      enabled    = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule

    content {
      id                                     = lookup(lifecycle_rule.value, "rule_name", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "tags", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      enabled                                = lifecycle_rule.value.enabled

      dynamic "expiration" {
        for_each = length(lookup(lifecycle_rule.value, "expiration", {})) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]

        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(lifecycle_rule.value, "transition", [])

        content {
          date          = lookup(transition.value, "date", null)
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = length(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]

        content {
          days = noncurrent_version_expiration.value.days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])

        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = length(var.server_side_encryption) == 0 ? [] : [var.server_side_encryption]

    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = lookup(server_side_encryption_configuration.value, "kms_master_key", null)
          sse_algorithm     = server_side_encryption_configuration.value.sse_algorithm
        }
      }
    }
  }

  dynamic "logging" {
    for_each = length(var.logging) == 0 ? [] : [var.logging]

    content {
      target_bucket = logging.value.target_bucket
      target_prefix = lookup(logging.value, "target_prefix", null)
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  count = can(regex("[0-9A-Za-z_]+", var.policy)) ? 1 : 0

  bucket = aws_s3_bucket.s3.id
  policy = var.policy
}