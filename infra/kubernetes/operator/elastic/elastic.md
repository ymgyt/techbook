# Elastic Cloud on KUbernetes

* operatorのnamespaceは`elastic-system`

## Install

1. Install crd

```shell

kubectl apply -f https://download.elastic.co/downloads/eck/2.6.1/crds.yaml
```

2. Install operator

```shell
kubectl apply -f https://download.elastic.co/downloads/eck/2.6.1/operator.yaml`
````

## Logs

```shell
kubectl -n elastic-system logs -f statefulset.apps/elastic-operator`
```

## Custom Resource

* Podの`resources.{requests,limit}`を指定しない場合operatorがdefault値を適用する
  * https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-managing-compute-resources.html#k8s-elasticsearch-memory

### Elasticsearch

```yaml
apiVersion: elasticsearch.k8s.elastic.co/v1
kind: Elasticsearch
metadata:
  name: quickstart
spec:
  version: 8.6.0
  nodeSets:
  - name: default
    count: 1
    podTemplate:
      spec:
        containers:
        - name: elasticsearch
          resources:
            requests:
              memory: 4Gi
              cpu: 1
            limits:
              # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-managing-compute-resources.html#k8s-elasticsearch-memory
              # The heap size of the JVM is automatically calculated based on limits.memory
              memory: 4Gi
```


### Kibana

```yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: quickstart
spec:
  version: 8.6.0
  podTemplate:
    spec:
      containers:
      - name: kibana
        env:
          - name: NODE_OPTIONS
            value: "--max-old-space-size=2048"
        resources:
          requests:
            memory: 1Gi
            cpu: 0.5
          limits:
            memory: 2.5Gi
            cpu: 2
```

### APM Server

```yaml
apiVersion: apm.k8s.elastic.co/v1
kind: ApmServer
metadata:
  name: quickstart
spec:
  version: 8.6.0
  podTemplate:
    spec:
      containers:
      - name: apm-server
        resources:
          requests:
            memory: 1Gi
            cpu: 0.5
          limits:
            memory: 2Gi
            cpu: 2
```