# replacements

* kustomizeの文字列置換機能

resource定義

* 以下のPodのcontainerの引数, `--host`にServiceの名前を渡したい
  * namePrefix等でServiceの名前が変わっても追従したい(hardcodeできない)

```yaml

apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: myapp
    image: app
    args: ["--host", "WILL_BE_REPLACED"]
---
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec: {}
```

kustomization

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- app.yaml
namePrefix: prod-
replacements:
- source: 
    name: myapp
    kind: Service
    version: v1
  targets:
  - select: 
      kind: Pod
      name: myapp
    fieldPaths:
    - spec.containers.[name=myapp].args.1
# 別fileにも切り出せる
- path: another_file.yaml
```


## varsとの相違点

* `x-$(PARTIAL_REPLACE)`のようにvarsだと一部を置換できるが、replacementだと部分置換ができない
