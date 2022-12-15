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

## Metrics

種別があるらしい

* gauge(ゲージ)
* counter

### Gauge




## Prometheus UI

defaultでは`localhost:9090`に立ち上がる。

## `prometheus.yml`

```yaml
global:
  scrape_interval: 10s

scrape_configs:
  # label job=prometheus のようになる
  - job_name: "prometheus"
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
