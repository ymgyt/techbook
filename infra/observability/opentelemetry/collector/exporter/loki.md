# Loki exporter

```yaml
processors:
  resource:
    attributes:
    # logのformatを指定
    - action: insert
      key: loki.format
      value: logfmt

exporters:
  loki:
    endpoint: ${env:LOKI_ENDPOINT}
    default_labels_enabled:
      exporter: false
      job: false
      instance: false
      level: false
```

* `default_labels_enabled`の各fieldをすべてfalseにすると、自動の変換をしなくなる

* resourceの`loki.format` attributeでlogのformatを指定できる
  * logfmt,json,raw

## 参考

* [README](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/lokiexporter#format)
