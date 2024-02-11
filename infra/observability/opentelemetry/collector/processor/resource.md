# Resource processor

telemetry dataのresourceのattributeに基づく操作


```yaml
processors:
  resource:
    attributes:
      - action: insert
        key: loki.resource.labels
        value: service.namespace
```

* `action`としてなにができるかはattribute processorを参照
