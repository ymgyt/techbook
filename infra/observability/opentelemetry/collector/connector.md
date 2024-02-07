# Connector

* pipelineをつなぐ役割を果たす

```yaml
connectors:
  forward: {}
  
services:
  pipelines:
    logs/in:
      receivers: [otlp]
      processors: [redact]
      exporters: [forward]

    logs/hot:
        recerivers: [forward]
        processors: [filter, label]
        exporters: [hot]

    logs/cold:
      recerivers: [forward]
      processors: [batch]
      exporters: [cold]
```

* あるpipelineのexporterと別のpipelineのreceriverとして現れる
  * 結果的にredact processorをlogs/hotとlogs/coldで共有できている
