resource "aws_dynamodb_table" "rides_table" {
  name           = "Rides"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }
}
