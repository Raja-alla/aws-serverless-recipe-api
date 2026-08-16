output "dynamodb_table_name" {
  value = module.dynamodb.dynamodb_table_name

}

output "dynamodb_table_arn" {
  value = module.dynamodb.dynamodb_table_arn

}

output "api-url" {
  value = module.api_gateway.api-url

}