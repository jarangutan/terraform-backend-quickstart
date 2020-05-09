#### DynamoDB
locals {
  lock_key_id = "LockID"
}

resource "aws_dynamodb_table" "lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = local.lock_key_id

  attribute {
    name = local.lock_key_id
    type = "S"
  }
}
