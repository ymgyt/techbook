# Opentelemetry Collector

## Install

1. cert-managerのinstall


### cert-managerのinstall

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml  
```

## Manifests

```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: node-monitor
  namespace: monitoring
spec:
  image: ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.67.0
  mode: daemonset
  hostNetwork: true
  volumes:
  - name: hostfs
    hostPath:
      path: /
      type: Directory
  volumeMounts:
  - name: hostfs
    mountPath: /hostfs
    # https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
    mountPropagation: HostToContainer
    readOnly: true
  env:
  - name: NODE_NAME
    valueFrom:
      fieldRef:
        fieldPath: spec.nodeName 
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: service.name=hostmetrics,service.namespace=monitoring,host.name=$(NODE_NAME)
  
  config: |
    receivers:
      hostmetrics:
        root_path: /hostfs
        collection_interval: 1m
        # https://github.com/open-telemetry/OpenTelemetry-Collector-contrib/tree/main/receiver/hostmetricsreceiver#collecting-host-metrics-from-inside-a-container-linux-only
        scrapers:
          cpu:
            metrics:
              system.cpu.time: { enabled: true }
              system.cpu.utilization: { enabled: true }
          disk:
            metrics:
              system.disk.io: { enabled: true }
              system.disk.io_time: { enabled: true }
              system.disk.merged: { enabled: true }
              system.disk.operation_time: { enabled: true }
              system.disk.operations: { enabled: true }
              system.disk.pending_operations: { enabled: true }
              system.disk.weighted_io_time: { enabled: true }
          load:
            # specifies whether to divide the average load by the reported number of logical CPUs.
            cpu_average: false
            metrics:
              system.cpu.load_average.15m: { enabled: true }
              system.cpu.load_average.1m: { enabled: true }
              system.cpu.load_average.5m: { enabled: true }
          filesystem:
            metrics:
              system.filesystem.inodes.usage: { enabled: true }
              system.filesystem.usage: { enabled: true }
              system.filesystem.utilization: { enabled: true }
          memory:
            metrics:
              system.memory.usage: { enabled: true }
              system.memory.utilization: { enabled: true }
          network:
            metrics:
              system.network.connections: { enabled: true }
              system.network.dropped: { enabled: true }
              system.network.errors: { enabled: true }
              system.network.io: { enabled: true }
              system.network.packets: { enabled: true }
              system.network.conntrack.count: { enabled: false}
              system.network.conntrack.max: { enabled: false }
          # disable paging
          # paging: {}
          processes: 
            metrics:
              system.processes.count: { enabled: true }
              system.processes.created: { enabled: true }
          # 有効にするとpermission denied errorとなる
          # error reading process name for pid 1: readlink /hostfs/proc/1/exe: permission denied
          # process:
          #   metrics:
          #     process.cpu.time: { enabled: true }
          #     process.disk.io: { enabled: true }
          #     process.memory.physical_usage: { enabled: true }
          #     process.memory.virtual_usage: { enabled: true }
          #     process.context_switches: { enabled: true }
          #     process.cpu.utilization: { enabled: true }
          #     process.memory.usage: { enabled: true }
          #     process.memory.virtual: { enabled: true }
          #     process.open_file_descriptors: { enabled: false }
          #     process.paging.faults: { enabled: false }
          #     process.signals_pending: { enabled: false }
          #     process.threads: { enabled: true }
        
    processors:
      memory_limiter:
        check_interval: 1s
        limit_percentage: 75
        spike_limit_percentage: 15
      resourcedetection:
        # Reads resource information from the OTEL_RESOURCE_ATTRIBUTES environment variable.
        detectors: ["env"]
        timeout: 2s
        # determines if existing resource attributes should be overridden or preserved, defaults to true
        override: true
      batch:
        send_batch_size: 10000
        timeout: 10s

    exporters:
      # https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/loggingexporter/README.md
      logging:
        # detailed | normal | basic
        verbosity: normal
        sampling_initial: 2
        sampling_thereafter: 500

      otlp/elastic:
        endpoint: "apm.monitoring:8200"
        tls:
          insecure: true
              
    service:
      pipelines:
        metrics:
          receivers: [hostmetrics]
          processors: [memory_limiter, resourcedetection, batch]
          exporters: [logging, otlp/elastic]
```

* `spec`に定義できる内容はsrcを参照する
  * [opentelemetrycollector_types.go](https://github.com/open-telemetry/opentelemetry-operator/blob/v0.67.0/apis/v1alpha1/opentelemetrycollector_types.go)に定義してある。
  * versionに注意