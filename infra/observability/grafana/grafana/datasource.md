# Data source

## Provisioning

* `provisioning/datasources`配下にyamlを置いて設定できる
  * `provisioning`dir自体はconfigのpaths.provisioningで指定する

`provisioning/datasources/my.yaml`

```yaml
# 利用方法わかってない
apiVersion: 1

datasources:
  # UIで使われる名前
- name: Loki
  # ここは何で決まる..?
  type: loki
  # Server(grafana process)かBrowserのjsからアクセスするか
  # proxy | direct
  access: proxy
  # basic authorization使うか
  basicAuth: false
  # UIからの変更を許可するか
  editable: false
  # panel作成時に選ばれた状態にするか
  # organizationごとに1つかtrueにできない
  isDefault: false
  # configurationで参照するための識別子
  uid: loki
  # data sourceのurl. portも含む
  url: http://localhost:3100
```