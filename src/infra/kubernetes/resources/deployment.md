# Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tinypod
  namespace: tinypod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tinypod
  template:
    metadata:
      labels:
        app: tinypod
    spec:
      containers:
      - name: tinypod
        image: ymgyt/tinypod:0.1.0
        ports:
        - name: http
          containerPort: 8001
```

* containerの`ports[].name`を設定しておくとServiceのcontainerPortの指定に利用でき、Service側がcontainerのportを意識しなくてよいので好き

