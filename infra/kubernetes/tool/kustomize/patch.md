# Kustomize patch

```yaml
- op: add
  path: /spec/...
  value: foo

# DeploymentにnodeAffinityを追加する例
# base側にaffinityが定義されていない場合
# path: /spec/template/spec/affinity/nodeAffinityを書くとerrorになる
# like "doc is missing"
# これは恐らく、存在しないfieldを2段階以上、指定できないためと思われる
- op: add
  path: /spec/template/spec/affinity
  value:  
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: "foo"
                operator: "In"
                values: ["bar"]
```

