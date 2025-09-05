# High Availability Deployment

## Components

* Router
  * Web UIをserve

* Ingester
  * 永続化を担当。statefull

* Querier
  * query担当。stateless

* Compactor
  * parquetをmergeする
  * 1 instance前提?

* AlertManager
  * alertの実行、評価、通知を行う
  * optionalでalertquerierにqueryをoffloadできる?

* Actions
  * pythonのscript実行環境

* ReportServer
  * DashboardのPDF生成
  * headlessなchrominumを利用


### Ingester

* `ZO_MEMORY_CIRCUIT_BREAKER_ENABLED`

## Helm

```sh
curl https://raw.githubusercontent.com/openobserve/openobserve-helm-chart/main/charts/openobserve/values.yaml -o values.yaml

helm repo add openobserve https://charts.openobserve.ai
helm repo update

helm fetch --untar --untardir /tmp/charts openobserve/openobserve

helm template o2 --values ./values.yaml /tmp/charts/openobserve out> manifest.yaml
```
