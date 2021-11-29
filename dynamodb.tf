resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "instance_state_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "instance_id"

  attribute {
    name = "instance_id"
    type = "S"
  }


  tags = local.common_tags
}