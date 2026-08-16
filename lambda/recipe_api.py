import boto3
import json

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("serverless-recipes")


def lambda_handler(event, context):

    if "httpMethod" in event:
        http_method=event["httpMethod"]

        body=json.loads(event.get("body") or "{}")
        path_parameters=event.get("pathParameters") or {}
        recipe_id=path_parameters.get("id")

    else:


        action=event["action"]

        if action=="create":
            recipe_id = event["id"]
            name = event["name"]
            category = event["category"]

            table.put_item(
                Item={
                    "id": recipe_id,
                    "name": name,
                    "category": category
                }
            )

            return {
                "statusCode": 200,
                "body": "Recipe added successfully"
            }

        elif action=="get":
            recipe_id = event["id"]
            response=table.get_item(
                Key={
                    "id":recipe_id
                }
            )

            return{
                "statusCode":200,
                "body":response.get("Item",{})

            }

        elif action == "update":
            recipe_id = event["id"]
            name = event["name"]
            category = event["category"]

            table.update_item(
                Key={
                    "id": recipe_id
                },
                UpdateExpression="SET #n = :name, category = :category",
                ExpressionAttributeNames={
                    "#n": "name"
                },
                ExpressionAttributeValues={
                    ":name": name,
                    ":category": category
                }
            )

            return {
                "statusCode": 200,
                "body": "Recipe updated successfully"
            }


        elif action == "delete":
            recipe_id = event["id"]

            table.delete_item(
                Key={
                    "id": recipe_id
                }
            )

            return {
                "statusCode": 200,
                "body": "Recipe deleted successfully"
            }



        else:
            return{
                "statusCode":400,
                "body":"Invalid action"

            }

    if http_method=="POST":
        recipe_id=body["id"]
        name=body["name"]
        category=body["category"]

        table.put_item(
            Item={
                "id": recipe_id,
                "name": name,
                "category": category
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Recipe added successfully"
            })
        }

    elif http_method == "GET":

        response = table.get_item(
            Key={
                "id": recipe_id
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps(response.get("Item", {}))
        }

    elif http_method == "PUT":

        response = table.update_item(
            Key={
                "id": recipe_id
            },
            UpdateExpression="SET #name = :name, category = :category",
            ExpressionAttributeNames={
                "#name": "name"
            },
            ExpressionAttributeValues={
                ":name": body["name"],
                ":category": body["category"]
            },
            ReturnValues="ALL_NEW"
        )

        return {
            "statusCode": 200,
            "body": json.dumps(response.get("Attributes", {}))
        }

    elif http_method == "DELETE":

        table.delete_item(
            Key={
                "id": recipe_id
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Recipe deleted successfully"
            })
        }

    else:

        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": "Unsupported HTTP method"
            })
        }
            
                    
        




