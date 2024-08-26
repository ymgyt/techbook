# kustomization

```yaml

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources: []
# deprecated
vars: {}
```

## replacements

`vars`の後継機能

[replacements](./replacements.md)を参照

## vars

* resource定義で参照できる変数を定義する
* deprecatedでv1beta1では使えるが、stableではサポートされない
  * `replacements`が移行先

* usecase
  * podの引数にserviceの名前として`--host <service>`を渡したい
    * Serviceの定義でkustomizationのnamePrefixをつけた場合、podの定義も追従する必要がありつらい

kustomization

```yaml
vars:
- name: SOME_SECRET_NAME
  objref:
    kind: Secret
    name: my-secret
    apiVersion: v1
- name: MY_SERVICE_NAME
  objref:
    kind: Service
    name: my-service
    apiVersion: v1
  fieldref:
    fieldpath: metadata.name 
```

変数を参照するresource

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: myapp
    image: app
    # buildするとmy-serviceに解決される
    args: ["--host", "$(MY_SERVICE_NAME)"]
```

変数のsourceとなるresource

```yaml

apiVersion: v1
kind: Service
metadata:
  name: my-service
spec: {}
```


* `name` 変数の名前
  * 参照できる場所は限られている
  * 具体的には[varreference.go](https://github.com/kubernetes-sigs/kustomize/blob/release-kustomize-v5.4.3/api/internal/konfig/builtinpluginconsts/varreference.go)を参照
  * 拡張するには、configurationsでpathを教えてやる必要がある
* `objref` 変数の値(source)を保持するobject
* `fieldref` `objref`のobjectのfield path
  * optionalで省略された場合は`metadata.name`
