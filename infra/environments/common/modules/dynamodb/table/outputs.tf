output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = aws_dynamodb_table.table.arn
}
output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table"
  value       = aws_dynamodb_table.table.id
}