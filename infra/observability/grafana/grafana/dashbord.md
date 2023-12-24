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