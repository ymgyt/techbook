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
  # referenced by kibana
  name: monitoring
spec:
  version: 8.6.0
  nodeSets:
  - name: default
    count: 1
    config:
      node.store.allow_mmap: true
      # https://www.elastic.co/guide/en/elasticsearch/reference/8.6/geoip-processor.html#geoip-cluster-settings
      # 起動時にgeoipのdownload処理が走りreadiness probeに失敗するのでdisableにする
      ingest.geoip.downloader.enabled: false
    podTemplate:
      spec:
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: xxx
                  operator: In
                  values:
                  - "yyy"
        initContainers:
        - name: sysctl
          securityContext:
            privileged: true
            runAsUser: 0
          # node.store.allow_mmapをtrueにした場合以下の設定が必要
          # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-virtual-memory.html#k8s-virtual-memory
          # 262144は必要な最低値
          command: ['sh', '-c', 'sysctl -w vm.max_map_count=262144']
    volumeClaimTemplates:
    - metadata:
        # Do not change this name unless you set up a volume mount for the data path.
        name: elasticsearch-data
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 20Gi
        storageClassName: default
```

### Kibana

```yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  name: monitoring
spec:
  version: 8.6.1
  count: 1
  elasticsearchRef:
    name: monitoring
  config:
    # point to the elasticsearch cluster that agents should send data to.
    # https://<elasticsearch-name>-es-http.<namespace>.svc:9200
    # agentにdataの送信先のelasticsearchを教えてやる必要がある
    xpack.fleet.agents.elasticsearch.hosts: ["https:o//monitoring-es-http.monitoring.svc:9200"]

    # point to fleet server that agents should connect to.
    # https://<fleet-server-name>-agent-http.<namespace.svc:8200
    xpack.fleet.agents.fleet_server.hosts: ["https://fleet-server-agent-http.default.svc:8220"]
    xpack.fleet.packages:
      # required packages to enable fleet server and agents.
      # https://github.com/elastic/cloud-on-k8s/blob/2.6.0/config/recipes/elastic-agent/fleet-apm-integration.yaml
      # should use a fixed version instead of latest?
      - name: system
        version: latest
      - name: elastic_agent
        version: latest
      - name: fleet_server
        version: latest
      - name: apm
        version: latest
    # https://www.elastic.co/guide/en/fleet/current/agent-policy.html
    # https://www.elastic.co/guide/en/fleet/current/create-a-policy-no-ui.html#use-preconfiguration-to-create-policy
    xpack.fleet.agentPolicies:
      - name: Fleet Server on ECK policy
        id: eck-fleet-server
        # おそらくこれをtrueにしておくとfleet-serverに自動的に適用される
        is_default_fleet_server: true
        namespace: default
        monitoring_enabled:
          - logs
          - metrics
        unenroll_timeout: 900
        package_policies:
        - name: fleet_server-1
          id: fleet_server-1
          package:
            name: fleet_server
      - name: Elastic Agent on ECK policy
        id: eck-agent
        namespace: default
        monitoring_enabled:
          - logs
          - metrics
        unenroll_timeout: 900
        # おそらくこれをtrueにしておくとagentに自動的に適用される
        is_default: true
        package_policies:
          - name: system-1
            id: system-1
            package:
              name: system
          - name: apm-1
            package:
              name: apm
            inputs:
            - type: apm
              enabled: true
              vars:
              - name: host
                value: 0.0.0.0:8200
```


### Agent

* apmserverもagentを利用する

```yaml
---
apiVersion: agent.k8s.elastic.co/v1alpha1
kind: Agent
metadata:
  name: apm
spec:
  version: 8.6.0
  # Run fleet server and elastic agent
  mode: fleet
  # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-elastic-agent-fleet-configuration.html#k8s-elastic-agent-fleet-configuration-setting-referenced-resources
  kibanaRef:
    name: monitoring
  fleetServerRef:
    name: fleet-server
  deployment:
    replicas: 1
    podTemplate:
      spec:
        # この指定をいれないと起動時にエラーになる
        securityContext:
          runAsUser: 0
        volumes:
        # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-elastic-agent-fleet-known-limitations.html#k8s_storing_local_state_in_host_path_volume_2
        # この指定をいれておかないとhost pathをmountしようとするのでそれを無効にする
        - name: agent-data
          emptyDir: {}
        containers:
        - name: agent
          # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-managing-compute-resources.html#k8s-default-behavior
          resources:
            requests:
              memory: 350Mi
              cpu: 0.1
            limits:
              memory: 350Mi
              cpu: 0.5
---
apiVersion: agent.k8s.elastic.co/v1alpha1
kind: Agent
metadata:
  name: fleet-server
spec:
  version: 8.6.0
  mode: fleet
  fleetServerEnabled: true
  # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-elastic-agent-fleet-configuration.html#k8s-elastic-agent-fleet-configuration-setting-referenced-resources
  kibanaRef:
    name: monitoring
  elasticsearchRefs:
  - name: monitoring
  deployment:
    replicas: 1
    podTemplate:
      spec:
        # この指定をいれないと起動時にエラーになる
        securityContext:
          runAsUser: 0
        volumes:
        # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-elastic-agent-fleet-known-limitations.html#k8s_storing_local_state_in_host_path_volume_2
        # この指定をいれておかないとhost pathをmountしようとするのでそれを無効にする
        # fleet-serverだが、nameはagent-dataでよい
        - name: agent-data
          emptyDir: {}
        containers:
        - name: agent
          # https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-managing-compute-resources.html#k8s-default-behavior
          resources:
            requests:
              memory: 350Mi
              cpu: 0.1
            limits:
              memory: 350Mi
              cpu: 0.1

```

* fleet-serverとagent両方必要
  * `spec.fleetServerEnabled: true`を指定するとfleet-serverとして動作する
* `spec.kibanaRef`はどのkibanaで管理されるかを決めるのでagent,fleet-serverともに必要
* agentはfleet-serverから設定をもらうので、`spec.fleetServerRef`が必要
* fleet-serverはどのelasticsearchから設定をもらうかを知る必要があるので、`spec.elasticsearchRefs`が必要


## 参考

* https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-air-gapped.html
  * internet accessできない場合にeckを動かすには