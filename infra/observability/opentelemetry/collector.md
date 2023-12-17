# Opentelemetry Collector

## Receiver

### Filelog

```yaml
receivers:
  filelog:
    # kubelet creates log files according to the following convention.
    # /var/log/pods/<namespace>_<pod-name>_<pod-uuid>/<container>/<rstart_count>.log
    include: 
    - /var/log/pods/*/*/*.log
    # currently get every logs.
    exclude: []
    # at startup, where to start reading logs from the fil. 
    # begining | end
    start_at: end
    force_flush_period: 30s
    encoding: utf-8
    include_file_name: false
    include_file_path: true
    include_file_path_resolved: false
    # the duration between filesystem polls
    poll_interval: 30s
    fingerprint_size: 1kb
    # the maximum size of a log entry
    # protects agains reading large amounts of data into memory
    max_log_size: 1MiB
    max_concurrent_files: 1024
    attributes:
      env:  dev
    resource: {}
    # https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/v0.67.0/pkg/stanza/docs/operators/README.md#what-operators-are-available
    operators:
      - type: router
        id: get_format
        routes:
        # 出力formatはcontainer runtimeに依存している
        # containerdの場合はformatが変わるので対応が必要 
        - output: docker_parser
          expr: 'body matches "^\\{"'
        default: docker_parser
      - type: json_parser
        id: docker_parser
        output: extract_metadata_from_filepath
        parse_from: body
        parse_to: attributes
        on_error: send
        # parseの中にtimestamp parserを組み込める
        # json parserの後に呼び出されるのでその結果を前提にしてよい
        timestamp:
          parse_from: attributes.time
          layout_type: strptime
          # https://github.com/observiq/ctimefmt/blob/3e07deba22cf7a753f197ef33892023052f26614/ctimefmt.go#L63
          layout: '%Y-%m-%dT%H:%M:%S.%LZ'
      - type: regex_parser
        id: extract_metadata_from_filepath
        regex: '^.*\/(?P<namespace>[^_]+)_(?P<pod_name>[^_]+)_(?P<uid>[a-f0-9\-]{36})\/(?P<container_name>[^\._]+)\/(?P<restart_count>\d+)\.log$'
        parse_from: attributes["log.file.path"]
      - type: move
        from: attributes.container_name
        to: resource["k8s.container.name"]
      - type: move
        from: attributes.namespace
        to: resource["k8s.namespace.name"]
      - type: move
        from: attributes.pod_name
        to: resource["k8s.pod.name"]
      - type: move
        from: attributes.restart_count
        to: resource["k8s.container.restart_count"]
      - type: move
        from: attributes.uid
        to: resource["k8s.pod.uid"]
```

* includeで指定したfileを監視対象にする
* fileの1行はentryとして扱われ、`operators`で順番に処理される
  * 内部的にstanzaを利用している


### Prometheus

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: "0.0.0.0:4317"
  prometheus:
    config:
      scrape_configs:
      - job_name: graphql
        scrape_interval: 60s
        scrape_timeout: 5s
        metrics_path: "/metrics"
        scheme: http
        static_configs:
        - targets: ["0.0.0.0:9090"]
```

## Processor

```yaml
processors:
  memory_limiter:
    check_interval: 1s
    limit_percentage: 75
    spike_limit_percentage: 15
  batch:
    send_batch_size: 10000
    timeout: 10s
  resourcedetection:
    # Reads resource information from the OTEL_RESOURCE_ATTRIBUTES environment variable.
    detectors: ["env"]
    timeout: 2s
```

## Exporter

```yaml
    exporters:
      # https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/loggingexporter/README.md
      logging:
        # detailed | normal | basic
        verbosity: basic
        sampling_initial: 2
        sampling_thereafter: 500

      otlp/elastic:
        endpoint: "apm.monitoring:8200"
        tls:
          insecure: true
              
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


## Environment variable substitution

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
