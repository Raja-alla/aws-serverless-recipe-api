variable "aws_region" {
  description = "Name of region"
  type        = string
  default     = "ap-south-1"

}

variable "table_name" {
  description = "Name of table"
  type        = string
  default     = "serverless-recipes"

}

variable "lambda_function_name" {
  description = "Name of the recipe Lambda function"
  type        = string
  default     = "serverless-recipe-api"
}