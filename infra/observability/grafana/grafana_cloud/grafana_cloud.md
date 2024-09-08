# Grafana Cloud

## opentelemetry collectorからsignalを送る

```yaml
extensions:
  basicauth/metrics:
    client_auth:
      username: "${env:METRICS_USER}"
      password: "${env:METRICS_PASS}"
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: "0.0.0.0:4317"
exporters:
 debug: 
   verbosity: detailed      

 prometheusremotewrite:
   endpoint: ${env:METRICS_URL}
   resource_to_telemetry_conversion:
     enabled: false
   auth:
     authenticator: basicauth/metrics
  
service:
  extensions: [ basicauth/metrics ]
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [debug,prometheusremotewrite]
  
  telemetry:
    logs:
      level: DEBUG
```

* 各種endpointやcredentialは`https://grafana.com/orgs/{org}/stacks`で確認できる

* metrics
  * prometheus remotewriteを利用する
  * `promethuesremotewrite.endpoint`にはRemote Write Endpoint
  * `basicauthmetrics.username`にはUsername/Instance ID
  * `basicauthmetrics.password`にはPassword /API Token
