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
 
# ConfigMapを生成する 
configMapGenerator:
- name: postgres-init-sql
  files:
     # file名がkey, fileのcontentがvalueになる。
  -  init.sql
  options:
    # 生成されるconfig mapを他で参照する際にrandomな値があると参照できない
    disableNameSuffixHash: true
    
# Secretsを生成する
# 考え方はconfigMapGeneratorと同じ
# base64 encodeは自動で行われるので、fileはリテラルで書いて良い
secretGenerator:
- name: pgo-s3-cred
  files:
  - s3.conf
  options:
    disableNameSuffixHash: true

# Image
# Podのspec.containers.imageを書き換える
# image: busybox:1.2.3 => image: alpine:3.6に書き変わる
images:
- name: busybox
  newName: alpine
  newTag: 3.6


# deprecated
patchesStrategicMerge:
- replica_count.yaml

# derepcated
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

# patchesはstragtegicMergeとjson6902両対応
patches:
- target:
    group: elasticsearch.k8s.elastic.co
    version: v1
    kind: Elasticsearch
    name: monitoring
  patch: |-
    - op: add
      path: /spec/nodeSets/0/volumeClaimTemplates/0/spec/storageClassName
      value: xxx

# fileに分けることもできる
- path: patch.yaml
  target:
    group: apps
    version: v1
    kind: Deployment
    name: deploy.*
    labelSelector: "env=dev"
    annotationSelector: "zone=west"
- patch: |-
    - op: replace
      path: /some/existing/path
      value: new value    
  target:
    kind: MyKind
    labelSelector: "env=dev"
```

* patches
  * 操作対象の指定は`target`で指定する
    * group, version, kind, name, namespace, labelSelector and annotationSelectorで指定する
  * 変更対象のfieldは`patch.path`で指定する
    * 入れる要素はindexを書く
  * labelを対象にする際に`app.kubernetes.io/name`のようにlabel自体に`/`が含まれている場合
    * `path: /xxx/app.kubernetes.io~1name`のように`~1`を利用する

## References

- [Transformの解説が丁寧](https://atmarkit.itmedia.co.jp/ait/articles/2101/21/news004.html)

- [patches](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patches/)