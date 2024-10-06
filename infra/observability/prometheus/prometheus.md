# Prometheus

## Install

```shell
curl -sSLO https://github.com/prometheus/prometheus/releases/download/v2.40.5/prometheus-2.40.5.darwin-arm64.tar.gz
tar -xzf ./prometheus-2.40.5.darwin-arm64.tar.gz 
cd prometheus-2.40.5.darwin-arm64 
# Exec
./prometheus --help
```

## Memo

* prometheusは自身のmetricsを`/metrics`でexportしている

## job and instance

* instance: scrapeできるendpoint
  * single processに対応
* job: 同じ目的をもったinstanceのcollection
  * instanceはscalabilityのためにreplicatedされ複数ある
  * scraping processで自動で生成される
* job/instanceでmetricsをuniqueに識別できることが期待されている

```
- job: api-server
  - instance 1: 1.2.3.4:5670
  - instance 2: 1.2.3.4:5671
  - instance 3: 5.6.7.8:5670
  - instance 4: 5.6.7.8:5671
```

```yaml
scrape_configs:
  - job_name: 'api-servers'
    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']

```

## Metrics

種別があるらしい

* gauge(ゲージ)
* counter

### Gauge




## Prometheus UI

defaultでは`localhost:9090`に立ち上がる。

https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file

## `prometheus.yml`

```yaml
global:
  scrape_interval: 10s

scrape_configs:
  # label job=prometheus のようになる
  - job_name: "prometheus"
    scrape_interval: 60s
    scrape_timeout: 5s
    metrics_path: "/metrics"
    scheme: http
    static_configs:
      - targets: ["localhost:9090"]
```

## `docker-compose.yaml`

```yaml
services:
  prometheus:
    image: prom/prometheus:v2.40.5
    command: ["--config.file=/etc/prometheus/prometheus.yaml"]
    volumes:
      - ./prometheus.yaml:/etc/prometheus/prometheus.yaml
    ports:
      - "9090:9090"
```

* 9090はprometheus web ui
* localに`prometheus.yaml`が置いてある前提
