module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name

}

module "iam" {
  source             = "./modules/iam"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn

}

module "lambda" {
  source          = "./modules/lambda"
  function_name   = var.lambda_function_name
  lambda_role_arn = module.iam.lambda_role_arn

}

module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_function_name = var.lambda_function_name
  lambda_function_arn  = module.lambda.function_arn
}