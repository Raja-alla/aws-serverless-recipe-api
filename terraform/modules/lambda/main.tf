resource "aws_lambda_function" "recipe_api" {
  function_name = var.function_name
  role          = var.lambda_role_arn

  filename         = "${path.root}/lambda/recipe_api.zip"
  source_code_hash = filebase64sha256("${path.root}/lambda/recipe_api.zip")

  runtime = "python3.12"
  handler = "recipe_api.lambda_handler"
}