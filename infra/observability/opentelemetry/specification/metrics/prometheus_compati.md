# Prometheus Compability

PrometheusとOTelのmetricsの互換性について

## Jobとinstance

promehteusのそれぞれのlabelはotelのservice resourceからmappingされる
* `job`は`service.namespace/service.name`
* `instance`は`service.instance.id`

## target_info

metricsのresourceはtarget_info metricsに変換され、metricsのsourceに関する情報はjobとinstance以外は、target_infoを参照する必要がある。  
必要に応じて、promqlでmerge(join)する

以下のようにcollectorで明示的にresourceから、attributeに値をsetしておくと、target_infoに頼らずにresourceの情報を取得できる
```
processor:
  transform:
    metric_statements:
      - context: metric
        statements:
        - set(attributes["namespace"], resource.attributes["k8s_namespace_name"])
        - set(attributes["container"], resource.attributes["k8s.container.name"])
        - set(attributes["pod"], resource.attributes["k8s.pod.name"])
        - set(attributes["cluster"], resource.attributes["k8s.cluster.name"])
```

## OpenTelemetry Metric Structure

A metric in OTel is made up of several parts. Roughly:

1. Resource attributes which are key-value pairs describing the “source” of the metric. service.name is required.

For example:
 - service.name
 - service.namespace
 - service.instance.id
 - service.version
 - deployment.environment
 - k8s.cluster.name
 - k8s.node.name
 - k8s.namespace.name
 - k8s.pod.name
 - k8s.container.name
 - k8s.deployment.name
 - cloud.provider
 - cloud.region
 - cloud.availability_zone

2. Metric attributes describe the metric itself. name and type are required.
For example:
name=http.requests
type=counter
status.code=500
path=/login

3. The timestamp and value:
value=2000 @timestamp

## Prometheus Metric Structure

Prometheus has a flat structure for metrics. A metric is identified by a set of label value pairs, just like OTel Metric, but it doesn’t differentiate between labels describing the target and those describing the metric itself:

For example:

```
prometheus_http_requests_total{
  code="200", 
	handler="/static/*filepath", 
  cluster="dev-us-central-0", 
	container="prometheus", 
	instance="prometheus-0", 
	job="default/prometheus", 
	namespace="default",
} 1622 1680529110698
```

