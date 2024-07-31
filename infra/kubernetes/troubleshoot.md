# Troubleshoot

* `kubectl cluster-info`
  * `kubectl cluster-info dump`
* `kubectl get nodes`
* `kubectl get componentstatus`
* `kubectl get events`
* `kubectl describe pod`してEventsを確認する

## 参考

* [foxtech k8s troubleshooting](https://foxutech.com/category/kubernetes/k8s-troubleshooting/)
  

## Resourceが足りていない状況

* どう調査するか

## Field is immutable

当該resourceを一度削除したのち再作成するしかない

よくあるimmutable fields
* Deployment
  * label selector
* Job

## Podがpendingでscheduleされない

まずpending pod一覧を取得する

```sh
kubectl get pods --field-selector=status.phase=Pending -n kube-system
```

次にpendingなpodの詳細を確認する
```sh

```
