# AWS Serverless Recipe CRUD API

A serverless REST API built using Amazon API Gateway, AWS Lambda, Amazon DynamoDB, and Terraform. The project implements Create, Read, Update, and Delete (CRUD) operations for recipes.

## Architecture

```text
                         USER / CLIENT
                              |
                              | HTTP Request
                              v
                    +----------------------+
                    |     API GATEWAY      |
                    |                      |
                    |  /recipes            |
                    |  POST                |
                    |                      |
                    |  /recipes/{id}       |
                    |  GET / PUT / DELETE  |
                    +----------+-----------+
                               |
                               | Invoke
                               v
                    +----------------------+
                    |       LAMBDA         |
                    |   Python + Boto3     |
                    |                      |
                    |  Create              |
                    |  Read                |
                    |  Update              |
                    |  Delete              |
                    +----------+-----------+
                               |
                               | AWS SDK / Boto3
                               v
                    +----------------------+
                    |      DYNAMODB        |
                    |                      |
                    |  serverless-recipes  |
                    +----------------------+