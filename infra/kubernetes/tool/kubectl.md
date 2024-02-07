# kubectl

## global options

`kubectl options` ですべてのcommandに適用できるoptionを確認できる。(`-n` namespace設定とか)

### Logging Level

* `kubectl --v=1`のように指定する。0~9まで指定できて、9が一番詳しい
  * `--v=2`がrecommendedと書いてある

## config

`KUBECONFIG`環境変数で指定できる。もちろんflag(`--kubeconfig`)でも指定できる。  
`$HOME/.kube/config`がdefaultで検索されるのでそこに置いておくこともできる。

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

## Output format

### `go-template`

```shell
kubectl get secret secret-a -o go-template='{{.data.API_KEY | base64decode}}'
```

わかっている組み込み関数

* `base64decode`

## Usage

### jobを実行する

```shell
kubectl apply -f ./job_manifest.yaml

# cronjobからjobを実行する
kubectl create job <job_name> --from=cronjob/<cronjob_name> -n <namespace>

# 必要なら完了後のjobを削除する
kubectl delete job <job_name> -n <namespace>
```


### dry-runでmanifestを生成する

```shell
kubectl create svc clusterip test --tcp=80:80 --dry-run=client -o yaml > my_svc.yaml
```


## `logs`

```shell
# labelで絞り込む
kubectl logs -l app=nginx
```

## `auth`

```shell
# authorizationの確認
kubectl auth can-i create deployemtns --namespace dev
```

* 引数は<verb> <resource>

## `port-forward`

```shell
kubectl port-forward service/xxx <host_port>:<target_port>
```

* kubectlを実行しているhostからservice/deployment/podへport-forwardする
    * 外部に公開していないservice/podにhostからアクセスできるようになる

* `host_port`はhost側でbindするport
  * このportにcurl等でアクセスできる
* `target_port`はforward対象が公開しているport

## `drain`

```shell
# start drain
kubectl drain <node name>

# end maintenance
kubectl uncordon <node name>
```

* node上のpodを退避して、当該nodeをscheduling対象外にする
  * nodeのmaintenance時に利用するのがusecase

* `uncordon`でnodeを再びschedule対象にする
  * `cordon`は刑事事件とかでよくみる黄色いテープをはって封鎖する的な意味


## `diff`

適用するmanifestと現在の状態とのdiffをとれる。  
このmanifestを適用すると何が変わるかを知りたい時に便利。

```shell
kubectl diff -f deployment.yaml

kustoize build path/to/overlay | kubectl diff -f -
```
