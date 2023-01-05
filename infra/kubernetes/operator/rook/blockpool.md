# CephBlockPool

* PersistentVolumeClaimに対してPersistentVolumeを提供する仕組み
* `ceph.rook.io/v1:CephBlockPool`を用意する

## メンタルモデル

まず`CephBLockPool` CRを定義する

```yaml
apiVersion: ceph.rook.io/v1
kind: CephBlockPool
metadata:
  name: replicapool
  namespace: rook-ceph # namespace:cluster
spec:
```

次に`StorageClass`で参照する

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: rook-ceph-block
# Change "rook-ceph" provisioner prefix to match the operator namespace if needed
provisioner: rook-ceph.rbd.csi.ceph.com
parameters:
  # clusterID is the namespace where the rook cluster is running
  clusterID: rook-ceph
  # Ceph pool into which the RBD image shall be created
  pool: replicapool # 👈これがCephBlockPoolのmetadata.nameを参照
```

これで`PVC`を宣言するだけで`PV`が動的に作成される

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-rook-block-pvc
spec:
  storageClassName: rook-ceph-block
```



