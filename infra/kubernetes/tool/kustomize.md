# kustomize

kubectlによるresource管理にtemplateとDSLを持ち込まないことを意図して作られている。  

* directory pathを指定すると当該directoryの`kustomization.yaml`を見に行く。


## Usage

既存の設定にpatchを適用して、`apply`していく。

```text
~/someApp
├── deployment.yaml
├── kustomization.yaml
└── service.yaml
```

```shell
kustomize build ~/someApp | kubectl apply -f -
```

### 環境ごとの差分を`overlays`で表現する

```text
~/someApp
├── base
│   ├── deployment.yaml
│   ├── kustomization.yaml
│   └── service.yaml
└── overlays
    ├── development
    │   ├── cpu_count.yaml
    │   ├── kustomization.yaml
    │   └── replica_count.yaml
    └── production
        ├── cpu_count.yaml
        ├── kustomization.yaml
        └── replica_count.yaml
```

### `kustomization.yaml`

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# resourceのnamespaceを上書きする
# 指定されていても上書きする
# 指定されていない場合はこの値が利用される
# https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/namespace/
namespace: kustomized-namespace

# basesはdeprecatedなのでresourcesを利用する
resources:
- ../base  
- ../another

# 全てのresourceにlabelとselectorを追加する
# selectorにも追加され、deploymentのselector.matchLabelsにも挿入されるので注意
commonLabels:
  app: tinypod
  env: staging

# 古いdocだとpatchesになっているところはこれを使う
patchesStrategicMerge:
- replica_count.yaml

patchesJson6902:
- target:
    version: v1
    kind: Deployment
    name: my-deployment
  patch: |-
    - op: add
      path: /some/new/path
      value: value
    - op: replace
      path: /some/existing/path
      value: "new value"    
```

* patchesJson6902
  * labelを対象にする際に`app.kubernetes.io/name`のようにlabel自体に`/`が含まれている場合
    * `path: /xxx/app.kubernetes.io~1name`のように`~1`を利用する
    * http://jsonpatch.com/#json-pointer

## References

- [Transformの解説が丁寧](https://atmarkit.itmedia.co.jp/ait/articles/2101/21/news004.html)
