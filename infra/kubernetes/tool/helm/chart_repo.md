# Chart Repository

* 複数のchartをindexしている

```sh
# 一覧表示
helm repo list

# 登録
helm repo add bitnami https://charts.bitnami.com/bitnami

# 検索
helm search repo foo

# srcの取得
# <repo>/<char_name>
helm fetch openobserve/openobserve
```

## search

```sh
helm search repo openobserve
NAME                     CHART VERSION   APP VERSION  DESCRIPTION
openobserve/openobserve  0.40.2          v0.40.1      Logs, Metrics and Traces, Dashboards, RUM, Erro...

# 過去versionも表示
helm search repo foo --versions
```

* CHART VERSION: chart自体のversion
* APP VERSION: chartが主としてpackagingしているappのversion
