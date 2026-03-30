# API Gateway

* API管理のfullmanagedなsystem
* Control planeに種類がある
  * v1 REST
  * v2 HTTP
  * terraform resourceから違う

## v2 HTTP

### Mental Model

1. Client Request
2. API Gateway Endpoint
3. Stage
4. Route match
5. Integration
  * Lambda invoke


## Stage

* APIのdeployment slot
* APIのprefixに差し込める仕組み
  * `$default` はprefixなし

* example
  * dev stage: `https://{api-id}.execute-api.{region}.amazonaws.com/dev/...`
  * default stage: `https://{api-id}.execute-api.{region}.amazonaws.com/...`

## Route

* integrationの切り替えlayer
* `$default` はcatch all
