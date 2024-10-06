# OTTL

OpenTelemetry Transform Language

## Context

* statementが参照できる暗黙的なデータ構造への参照?

## Funcitons

https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/pkg/ottl/ottlfuncs#ottl-functions

## Config

```text
processors:
  transform:
    error_mode: ignore
    # trce_statements | metric_statements | logs_statements
    trace_statements:
      - context: <context>
        statements:
          - <statement>
          - <statement>
          - <statement>
       - context: <context>
          statements:
          - <statement>
          - <statement>
          - <statement>

service:
  pipelines:
    traces:
      processors: [transform]
```

* `error_mode`
  * `ignore`: errorを無視して処理を継続。default
  * `propagate`: collectorはpayloadをdropする
