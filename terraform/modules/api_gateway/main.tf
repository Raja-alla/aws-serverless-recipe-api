data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "recipes" {
  name        = "serverless-recipe-api"
  description = "API for serverless recipes application"

}

resource "aws_api_gateway_resource" "recipes" {
  rest_api_id = aws_api_gateway_rest_api.recipes.id
  parent_id   = aws_api_gateway_rest_api.recipes.root_resource_id
  path_part   = "recipes"

}

resource "aws_api_gateway_resource" "recipe_by_id" {
  rest_api_id = aws_api_gateway_rest_api.recipes.id
  parent_id   = aws_api_gateway_resource.recipes.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_recipe" {
  rest_api_id   = aws_api_gateway_rest_api.recipes.id
  resource_id   = aws_api_gateway_resource.recipe_by_id.id
  http_method   = "GET"
  authorization = "none"


}

resource "aws_api_gateway_integration" "get_recipe" {
  rest_api_id             = aws_api_gateway_rest_api.recipes.id
  resource_id             = aws_api_gateway_resource.recipe_by_id.id
  http_method             = aws_api_gateway_method.get_recipe.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"

}

resource "aws_api_gateway_method" "update_recipe" {
  rest_api_id   = aws_api_gateway_rest_api.recipes.id
  resource_id   = aws_api_gateway_resource.recipe_by_id.id
  http_method   = "PUT"
  authorization = "none"


}

resource "aws_api_gateway_integration" "update_recipe" {
  rest_api_id             = aws_api_gateway_rest_api.recipes.id
  resource_id             = aws_api_gateway_resource.recipe_by_id.id
  http_method             = aws_api_gateway_method.update_recipe.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"

}

resource "aws_api_gateway_method" "delete_recipe" {
  rest_api_id   = aws_api_gateway_rest_api.recipes.id
  resource_id   = aws_api_gateway_resource.recipe_by_id.id
  http_method   = "DELETE"
  authorization = "none"


}

resource "aws_api_gateway_integration" "delete_recipe" {
  rest_api_id             = aws_api_gateway_rest_api.recipes.id
  resource_id             = aws_api_gateway_resource.recipe_by_id.id
  http_method             = aws_api_gateway_method.delete_recipe.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"

}

resource "aws_api_gateway_method" "create_recipe" {
  rest_api_id   = aws_api_gateway_rest_api.recipes.id
  resource_id   = aws_api_gateway_resource.recipes.id
  http_method   = "POST"
  authorization = "none"


}

resource "aws_api_gateway_integration" "create_recipe" {
  rest_api_id             = aws_api_gateway_rest_api.recipes.id
  resource_id             = aws_api_gateway_resource.recipes.id
  http_method             = aws_api_gateway_method.create_recipe.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.id}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"

}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.recipes.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "recipes" {
  rest_api_id = aws_api_gateway_rest_api.recipes.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.recipes.id,
      aws_api_gateway_resource.recipe_by_id.id,

      aws_api_gateway_method.create_recipe.id,
      aws_api_gateway_method.get_recipe.id,
      aws_api_gateway_method.update_recipe.id,
      aws_api_gateway_method.delete_recipe.id,

      aws_api_gateway_integration.create_recipe.id,
      aws_api_gateway_integration.get_recipe.id,
      aws_api_gateway_integration.update_recipe.id,
      aws_api_gateway_integration.delete_recipe.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.create_recipe,
    aws_api_gateway_integration.get_recipe,
    aws_api_gateway_integration.update_recipe,
    aws_api_gateway_integration.delete_recipe
  ]
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.recipes.id
  deployment_id = aws_api_gateway_deployment.recipes.id
}