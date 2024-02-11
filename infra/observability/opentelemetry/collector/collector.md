# Opentelemetry Collector

## Config

```yaml
service:
  pipelines:
    metrics:
      receivers: [hostmetrics, kubeletstats]
      processors: [memory_limiter, resourcedetection, batch]
      exporters: [otlp/elastic]
    logs:
      receivers: [filelog]
      processors: [memory_limiter, resourcedetection, batch]
      exporters: [otlp/elastic]
```

## Service

```yaml
receiver:
  hostmetrics: {}
processor:
  resourcedetection/system: {}
exporter:
  logging: {}

service:
  pipelines:
    metrics:
      receivers: [hostmetrics]
      processors: [resourcedetection/system]
      exporters: [logging]

  extensions: [memory_ballast]

  telemetry:
    logs:
      level: INFO
      development: false
      encoding: console # | json
      disable_caller: false
      disable_stacktrace: false
      output_paths: ["stderr"]
      error_output_paths: ["stderr"]
      initial_fields: [""]
    metrics:
      level: basic # none | basic | normal | detailed
      address: 127.0.0.1:8888
```

* `extensions`はtop levelのextensionのうち有効にするものを指定
* `telemetry`はcollector自身の情報出力を制御
  * defaultでは`http://127.0.0.1:8888/metrics`でlistenしている


### Environment variable substitution

設定fileの中でcollector実行時の環境変数を参照する。 
exporter等の設定にcredentialを参照したい場合にconfig.yamlに直接かかなくてよくなる。

```yaml
processors:
  attributes/example:
    actions:
      - key: ${env:DB_KEY}
        action: ${env:OPERATION}
```

* `${env:ENV_KEY}`で置換される。  
  * nix等では`$`をescapeする必要があるので注意
  * literalの`$`を表現するには`$$`を使う
