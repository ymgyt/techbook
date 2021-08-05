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
