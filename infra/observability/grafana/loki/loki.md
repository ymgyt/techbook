# Loki


## Usage

```sh
loki \
  -config.file=/etc/loki/config.yaml \
  -target=all
```

## Configuration

* `loki.yaml`がconvention
* `-config.file`で渡す
  * 複数渡す場合は最初に見つけたものを使う
  * 指定しない場合はcurrent dirの`config.yaml`を読む
    * `config/config.yaml`も探す

```yaml
# X-Scope-OrgID http headerによる認証を有効にするか
# falseならOrgIDは'fake'になる
auth_enabled: false
  # 各moduleの共通設定
  common:
    compactor_address: 'loki'
    # よくわからず
    path_prefix: /var/loki
    replication_factor: 1
    storage:
      s3:
        access_key_id: ${GRAFANA_LOKI_S3_ACCESKEYID}
        bucketnames: loki-chunks
        endpoint: ${GRAFANA_LOKI_S3_ENDPOINT}
        insecure: true
        s3forcepathstyle: true
        secret_access_key: ${GRAFANA_LOKI_S3_SECRETACCESSKEY}
  frontend:
    scheduler_address: ""
  frontend_worker:
    scheduler_address: ""
  index_gateway:
    mode: ring
  limits_config:
    enforce_metric_name: false
    ingestion_burst_size_mb: 24
    ingestion_rate_mb: 16
    max_cache_freshness_per_query: 10m
    reject_old_samples: true
    reject_old_samples_max_age: 168h
    split_queries_by_interval: 15m
  memberlist:
    join_members:
    - loki-memberlist
  query_range:
    align_queries_with_step: true
  ruler:
    storage:
      s3:
        access_key_id: ${GRAFANA_LOKI_S3_ACCESKEYID}
        bucketnames: loki-ruler
        endpoint: ${GRAFANA_LOKI_S3_ENDPOINT}
        insecure: true
        s3forcepathstyle: true
        secret_access_key: ${GRAFANA_LOKI_S3_SECRETACCESSKEY}
      type: s3
  runtime_config:
    file: /etc/loki/runtime-config/runtime-config.yaml
  schema_config:
    configs:
    - from: "2022-01-11"
      index:
        period: 24h
        prefix: loki_index_
      object_store: s3
      schema: v12
      store: boltdb-shipper
  server:
    grpc_listen_port: 9095
    grpc_server_max_recv_msg_size: 33554432
    grpc_server_max_send_msg_size: 33554432
    http_listen_port: 3100
  storage_config:
    hedging:
      at: 250ms
      max_per_second: 20
      up_to: 3
```


