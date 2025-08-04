# LocalStack

## Docker compose

```yaml
localstack:
  image: localstack/localstack:4.7.0
  environment:
    - SERVICES=sqs
    - GATEWAY_LISTEN=4566
    - DEBUG=1
  ports: ["4566:4566"]
  volumes:
    - type: bind
      source: localstack/init.sh
      target: /etc/localstack/init/read.d/init.sh
```
