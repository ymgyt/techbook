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
```

* `env.[].valueFrom.secretKeyRef`でsecretを参照できる
* `env.[].valueFrom.configMapKeyRef`でconfigmapを参照できる
