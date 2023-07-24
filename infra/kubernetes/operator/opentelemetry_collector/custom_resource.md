# Opentelemetry Custom Resouce

## Example

```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: example
spec:
  image: ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.70.0
  mode: deployment
  # serviceAccount: example 
  env:
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: service.name=node-monitor,service.namespace=monitoring,host.name=$(NODE_NAME)
  config: |
    receivers: {}
    processors: {}
    exporters: {}
  service:
    pipelines:
      traces: {}
      metrics: {}
 ```