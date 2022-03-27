# Pod

## Env

```yaml
spec:
  containers:
  - name: mongodb
    image: mongo
    ports:
    - containerPort: 27017
    env:
    - name: MONGO_INITDB_ROOT_USERNAME
      valueFrom:
        secretKeyRef:
          name: mongodb-secret
          key: mongo-root-username
    - name: ME_CONFIG_MONGODB_SERVER
      valueFrom:
        configMapKeyRef:
          name: mongodb-configmap
          key: database_url
    envFrom:    
   - configMapRef:    
       name: ceph-bucket    
   - secretRef:    
       name: ceph-bucket    
```

* `env.[].valueFrom.secretKeyRef`でsecretを参照できる
* `env.[].valueFrom.configMapKeyRef`でconfigmapを参照できる
* `envFrom.{configMapRef,secretRef}`でconfig/secretの値をすべて環境変数として取り込める
  * 衝突した際の挙動は要調査。

## Image Pull Policy

* `imagePullPolicy`が指定されておらず、(tagが`:latest`の場合 or tagが指定されていない場合)、`Always`になる
* `imagepullPolicy`が指定されておらず、tagが指定されている場合、`IfNotPresent`になる
