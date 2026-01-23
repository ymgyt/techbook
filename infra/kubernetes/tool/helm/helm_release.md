# Helm Release

* Chart + values = Release
* Releaseはsecretとしてkubernetesに保存される
* 同じchartを複数回installするのは通常のユースケース
  * DB Instanceを2つ用意したり

```sh
# list releases
# namespacedなので必要なら指定
helm list
helm list --namespace foo
helm list --all-namespaces

# status
helm status release_foo
```

## Install

```sh
helm upgrade
  --install
  --values values.yaml
  --set foo.bar.name="name"
  --namespace $namespace
  $rel_name $chart_ref
```

* `helm install`と`helm upgrade --install` は同じらしい

* release nameのscopeはnamespaced

* `--set`で特定のfieldを指定できる

  ```yaml
  # --set foo.bar.name
  foo:
    bar:
      name: "SET ME"
  ```

* chart_ref: 複数の指定が可能
  * `<repo>/<chart_name>`: chart name指定


### upgrade

* configuration(values)を更新したい場合とchart versionを更新したい場合がある

```sh
# initial release
helm upgrade --install --values values.yaml $rel_name

# edit values.yaml
# apply new configs
helm upgrade --values values.yaml $rel_name

# 新しいchartを適用する場合
helm repo update
helm upgrade --values values.yaml --version $new_chart_ver $rel_name 
```

* chart versionを更新する場合は`helm upgrade --version`でchart versionを指定する

* `--reuse-values`を使うと前回と同じvaluesを適用できるが非推奨?


## uninstall

```sh
helm uninstall $rel_name -n $namespace
```
* `--keep-history`
