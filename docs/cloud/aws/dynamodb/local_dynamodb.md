# Local DynamoDB

開発時に利用できるDynamoDBのlocal版

## Dockerfile

```
FROM amazon/dynamodb-local:1.17.0
EXPOSE 8000
WORKDIR /home/dynamodblocal
CMD ["-jar", "DynamoDBLocal.jar", "sharedDb", "-dbPath", ".", "-delayTransientStatuses", "-port", "8000"]
```

docker-compose

```yaml
version: '3.7'
services:
  dynamodb:
    build:
      context: ./dev
      dockerfile: DynamodbDockerfile
    container_name: taskmanager_dynamodb
    ports:
      - 40001:8000
```

## Help

```shell
docker run amazon/dynamodb-local:1.17.0  -jar DynamoDBLocal.jar -help
```
