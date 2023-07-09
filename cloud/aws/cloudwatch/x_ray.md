# X-Ray

## Trace

### Query

keyword operator valueをAND/ORでつなげていくのが基本形。  
serviceやannotation等は予約後  
参考: https://docs.aws.amazon.com/xray/latest/devguide/xray-console-filters.html#console-filters-syntax

* `service("xxx") AND annotation.http_route = "/v1/foo"`

```text
service("xxx") AND
annotation.otel_resource_deployment_environment = "staging" AND
annotation.http_route = "/v1/xxx" AND
annotation.xxx_yyy >= 0.2 AND
duration >= 0.5
```