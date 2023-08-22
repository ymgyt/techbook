# Resise Persistent Volume

https://www.elastic.co/guide/en/cloud-on-k8s/2.6/k8s-troubleshooting-methods.html#k8s-resize-pv

* StatefusSetではPersistentVolumeClaimからのsize変更ができない
* nodeSetの名前を変えるとOperator側でデータ移行してくれる