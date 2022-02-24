# kubectl

## global options

`kubectl options` ですべてのcommandに適用できるoptionを確認できる。(`-n` namespace設定とか)

### Logging Level

* `kubectl --v=1`のように指定する。0~9まで指定できて、9が一番詳しい
  * `--v=2`がrecommendedと書いてある

## config

`KUBECONFIG`環境変数で指定できる。もちろんflagでも指定できる。

## Plugin

* cargoのように`kubectl xxx`が実行されると`PATH`から`kubectl-xxx`という実行fileを探して実行してくれる
* `kubectl plugin list`で一覧を確認できる

### `kubectl whoami`

`kubectl-whoami`として保存する。
```shell
#!/bin/bash

# this plugin makes use of the `kubectl config` command in order to output
# information about the current user, based on the currently selected context
kubectl config view --template='{{ range .contexts }}{{ if eq .name "'$(kubectl config current-context)'" }}Current user: {{ printf "%s\n" .context.user }}{{ end }}{{ end }}'
```

```shell
chmod +x ./kubectl-whoami
sudo mv ./kubectl-whoami /usr/local/bin/
kubectl whoami
```

## Usage

### podに接続する(containerの中でcommandを実行する) 

kubectl get pods等で事前に対象のpod, containerを把握しておく。  
当然container imageにshellがあることが前提。

```
# shell
kubectl exec <pod> --container <container> -n <namespace> --tty --stdin -- /bin/sh

# 特定のcommandを実行
kubectl exec <pod> --container <container> -n <namespace> --tty --stdin -- /path/app command --arg value
```

### podの一覧を表示する

```shell
# labelでfilterできる
kubectl get pods -n <namespace> -l <label_name>=<label_value>
```

### jobを実行する

```shell
kubectl apply -f ./job_manifest.yaml

# cronjobからjobを実行する
kubectl create job <job_name> --from=cronjob/<cronjob_name> -n <namespace>

# 必要なら完了後のjobを削除する
kubectl delete job <job_name> -n <namespace>
```

### yamlを適用する

```shell
kubectl apply -f path/to/object.yaml
```

### configを確認する

```shell
kubectl config view

# 適用されているcontextを表示
kubectl config current-context
```

### secretの中身をみる

```shell
kubectl get secret xxx-secret -o jsonpath="{.data.key1}" | base64 -d; 
```

### cluster IPで公開されているserviceにlocalから接続する

```shell
kubectl port-forward svc/service-xxx 8080:443
```

### APIに登録されている全てのresourceを確認する

```shell
# kubectl get all --all-namespace はすべてを表示しない
kubectl api-resources
```
