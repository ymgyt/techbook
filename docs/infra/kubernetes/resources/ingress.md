# Ingress

* 外からのaccessを処理するobject
  * load balancing, TLS termination
* ingress controllerの存在が前提
  * ingressだけ作っても意味がない

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```

* ingress controllerをmetadata.annotationsで制御する
* きたrequestをどこに流すかだけを定義している
