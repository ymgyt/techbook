# Persistent Volume

## PVとPVCの関係

まず物理的なstorage(HDD)がある。  
これをPVとして表現してKubernetesに認識させる。  
様々なユースケースに対応できるようにPVをいろいろ作成しておく(size,speed)。  
PodはPVCを宣言して必要なstorageを宣言する。
なんらかのControl loopがPVCを監視して、PVCのspecに合致したPVとbindする。  
この際、k8sの環境によっては動的にPVが作成されたりもする。  

PVCとPVの関係は**1:1**


## Persistent Volume

Kubernetesに物理的なstorageを認識させるためのapi object.  
実際のstorageの情報を保持している。  
宣言されたPersistentVolumeに対応するstorageの実体を用意するのはcluster adminかcloud providerの責務。

### Reclaim Policy

BindされたPVCが削除された場合にPersistentVolumeに何が起きるかを定義する。  
Dynamically createdなPVの場合はstorage classに定義する。  
Statically createdな場合はPersistentVolumeに定義する。

* `Retain`: PVCが削除されてもPVはそのままで、bindからreleaseされる
* `Delete`: PVを削除
* `Recycle`: deprecated


## Persistent Volume Claim

Podから実際に使われるstorageを抽象化して切り離すレイヤー。  
Storageに対する期待を宣言する責務。10G欲しいと宣言させて、実際に利用するstorageの実体は100Gみたいなことがしたい。

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: "my-pvc"
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 250Mi
```

### PVCがPodに使われているか確かめる方法

* `kubectl describe pvc my-pvc`して、`Used By`をみる
