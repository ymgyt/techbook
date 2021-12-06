# Create DynamoDB Table

```shell
#!/bin/bash

# Create dynamodb tables by call api.
# This script is intended to be used for local development.
# It is assumed that AWS credential is set in the environment variables.

set -o nounset
set -o pipefail
set -o errexit

# Dynamodb api listen port
DYNAMODB_PORT="40001"

# Dynamodb api endpoint
DYNAMODB_ENDPOINT="http://localhost:${DYNAMODB_PORT}"

# Generate by `aws dynamodb create-table --generate-cli-skeleton`
# ProvisionedThroughput is ignored in downloadable dynamodb
# https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html
DYNAMODB_CREATE_TABLE_PARAM=$(cat <<EOF
{
    "AttributeDefinitions": [
        {
            "AttributeName": "id",
            "AttributeType": "S"
        },
        {
            "AttributeName": "created_at",
            "AttributeType": "S"
        }
    ],
    "TableName": "tasks",
    "KeySchema": [
        {
            "AttributeName": "id",
            "KeyType": "HASH"
        },
        {
            "AttributeName": "created_at",
            "KeyType": "RANGE"
        }
    ],
    "BillingMode": "PROVISIONED",
    "ProvisionedThroughput": {
        "ReadCapacityUnits": 100,
        "WriteCapacityUnits": 100
    }
}
EOF
)

function main() {

  aws dynamodb create-table \
    --cli-input-json "${DYNAMODB_CREATE_TABLE_PARAM}" \
    --endpoint-url="${DYNAMODB_ENDPOINT}"

  aws dynamodb list-tables --endpoint-url="${DYNAMODB_ENDPOINT}"

}

main ${@+"$@"}
```
