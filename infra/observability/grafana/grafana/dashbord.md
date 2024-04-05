# Dashboard

* `provisioning/dashbords`配下にyamlを置いて設定できる

```yaml
apiVersion: 1
  providers:
  - disableDeletion: true
    editable: false
    folder: ""
    name: loki1
    options:
      path: /var/lib/grafana/dashboards/loki1
    type: file
```

## Visualization

* [公式visualization doc](https://grafana.com/docs/grafana/latest/visualizations/)

## Design

* **Every dashboard should have a goal or purpose**

## Link

* panel link
  * URLに特殊な変数を利用でき、click時に置換できる
    * 現在のtime rangeとかを渡せる
* data link
