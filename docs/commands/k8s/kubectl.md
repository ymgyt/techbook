# kubectl

## global options

`kubectl options` ですべてのcommandに適用できるoptionを確認できる。(`-n` namespace設定とか)

## config

`KUBECONFIG`環境変数で指定できる。もちろんflagでも指定できる。

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
