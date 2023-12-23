# Basic Auth Extension

```yaml
extensions:
  basicauth/server:
    file: .htpasswd
    inline: |
        ${env:BASIC_AUTH_USERNAME}:${env:BASIC_AUTH_PASSWORD}

  basicauth/metrics:
    client_auth:
      username: "${env:USER}"
      password: "${env:PASS}"

receivers:
  otlp:
    protocols:
      http:
        auth:
          authenticator: basicauth/server

exporters:

 prometheusremotewrite:
   endpoint: ${env:METRICS_URL}
   auth:
     authenticator: basicauth/metrics
  
service:
  extensions: [ basicauth/server, basicauth/metrics ]
  pipelines:
    metrics: {}
```


* extensionで定義して、receiver,exporterで参照する
  * `service.extensions`に定義しないと有効にならない

* `basicauth.client_auth`はclient(exporter)で利用する
