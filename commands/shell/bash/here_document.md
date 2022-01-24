# Here Document


```shell
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
    ]
}
EOF
)

function main() {

  aws dynamodb create-table  --cli-input-json "${DYNAMODB_CREATE_TABLE_PARAM}"
```
