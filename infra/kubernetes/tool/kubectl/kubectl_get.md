# kubectl get

* `-o`でoutputの形式を指定
  * `wide` PodのnodeとIDも表示
  * `yaml` yaml形式manifestを取得できる

* `-l name=value` labelでqueryをうつ


## Usage

```sh
# nameのみ表示
kubectl get pods -o 'go-template={{range .items}}{{printf "%s\n" .metadata.name}}{{end}}'

# secretの確認
kubectl get secret xxx-secret -o jsonpath="{.data.key1}" | base64 -d; 

# 全て(全てではない)
kubectl get all
```

