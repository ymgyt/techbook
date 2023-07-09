# ObjectStore

S3API互換のstorageを用意できる。  
具体的にはaws s3 clientからbucketを作成したりobject(file)をputしたりできる。

##  メンタルモデル

まず`CephObjectStore`を定義する。

```yaml
apiVersion: ceph.rook.io/v1
kind: CephObjectStore
metadata:
  name: test-store
  namespace: rook-ceph
spec:
  metadataPool:
    failureDomain: host
    replicated:
      size: 3
  dataPool:
    failureDomain: host
    erasureCoded:
      dataChunks: 2
      codingChunks: 1
  preservePoolsOnDelete: true
  gateway:
    sslCertificateRef:
    port: 80
    # securePort: 443
    instances: 1
  healthCheck:
    bucket:
      disabled: false
      interval: 60s
```

これでS3apiをサポートする`Service`が作られる。

次に`StorageClass`を宣言する。

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: rook-ceph-bucket
# Change "rook-ceph" provisioner prefix to match the operator namespace if needed
provisioner: rook-ceph.ceph.rook.io/bucket
reclaimPolicy: Delete
parameters:
  objectStoreName: test-store # 👈CephObjectStore metadata.nameを参照
  objectStoreNamespace: rook-ceph
```

`ObjectBucketClaim`でbucketを作成する。  

```yaml
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: ceph-bucket
spec:
  generateBucketName: test-ceph-bkt
  storageClassName: rook-ceph-bucket
```

これで`CephObjectStore`(S3 API)配下にbucketが作成される。
