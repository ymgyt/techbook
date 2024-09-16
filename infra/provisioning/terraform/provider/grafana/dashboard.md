# Grafana Dashboard

```hcl
resource "grafana_folder" "syndicationd" {
  title                        = "Syndicationd"
  prevent_destroy_if_not_empty = false
}

resource "grafana_dashboard" "synd_api" {
  for_each    = fileset("${path.module}/dashboards", "*.json")
  config_json = file("${path.module}/dashboards/${each.key}")
  folder      = grafana_folder.syndicationd.id
  overwrite   = true
}
```

* `dashboards/app.json`のようにdashboards配下にdashboardからexportしたjsonを配置する

## Design

Dashboard作成における心構え

## References

* [Best practices](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/best-practices/)
  * 公式のbp集
* [A complete guide to all the different types](https://grafana.com/blog/2022/06/06/grafana-dashboards-a-complete-guide-to-all-the-different-types-you-can-build/?pg=webinar-getting-started-with-grafana-dashboard-design-amer&plcmt=related-content-1)
