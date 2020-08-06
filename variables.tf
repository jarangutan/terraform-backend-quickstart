variable "account_number" {
  description = "AWS Account number"
}

variable "region" {
  default = "us-east-1"
}

variable "noncurrent_version_expiration" {
  description = "Specifies when noncurrent object versions expire. See the aws_s3_bucket document for detail."

  type = object({
    days = number
  })

  default = null
}

variable "prefix" {
  default = "myapp"
}
