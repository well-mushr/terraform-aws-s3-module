variable "acl" {
  type        = string
  description = "(Optional) The canned ACL to apply"
  default     = "private"
}

variable "bucket_name" {
  type        = string
  description = "(Optional, Forces new resource) The bucket of the bucket. If omitted Terraform will assign a random, unique name."
  default     = null
}

variable "lifecycle_rule" {
  type        = any
  description = "(Optional) List of maps containing a configuration of object lifecycle management"
  default     = []
}

variable "logging" {
  type        = map(string)
  description = "(Optional) Map of strings defining the logging settings."
  default     = {}
}

variable "policy" {
  type        = string
  description = "(Optional) A valid bucket policy JSON document"
  default     = null
}

variable "server_side_encryption" {
  type        = map(string)
  description = "(Optional) A configuration of server-side encryption"
  default = {
    sse_algorithm = "aws:kms"
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Specifies a map object used to create tags."
  default     = {}
}

variable "versioning" {
  type        = map(string)
  description = "(Optional) Map containing a state of versioning configuration."
  default     = {}
}
