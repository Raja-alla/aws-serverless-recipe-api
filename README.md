# AWS Serverless Recipe CRUD API

A serverless REST API built using Amazon API Gateway, AWS Lambda, Amazon DynamoDB, and Terraform. The project implements Create, Read, Update, and Delete (CRUD) operations for recipes.

Infrastructure is provisioned using Terraform and automated through GitHub Actions using AWS OIDC authentication.

## Architecture

```text
                         DEVELOPER
                             |
                         Git Push
                             |
                             v
                    +-------------------+
                    |     GitHub        |
                    |     Actions       |
                    +---------+---------+
                              |
                    +---------+---------+
                    |                   |
                    v                   v
                  CI                    CD
          +----------------+    +----------------+
          | Terraform fmt  |    | Terraform      |
          | Validate       |    | Apply          |
          | Plan           |    +-------+--------+
          | Python Check   |            |
          +----------------+            |
                                        v
                              +-------------------+
                              |    AWS OIDC       |
                              |    IAM Role       |
                              +---------+---------+
                                        |
                                        v
                              +-------------------+
                              |     Terraform     |
                              +---------+---------+
                                        |
                                        v
              +-------------------------+-------------------------+
              |                         |                         |
              v                         v                         v
       +-------------+           +-------------+           +-------------+
       | API Gateway |           |   Lambda    |           |  DynamoDB   |
       |   REST API  |---------->|   Python    |---------->|   Recipes   |
       +-------------+           +-------------+           +-------------+

                     Terraform Remote State
                              |
                              v
                    +---------------------+
                    |     Amazon S3       |
                    |  .P2/terraform.tfstate |
                    +---------------------+