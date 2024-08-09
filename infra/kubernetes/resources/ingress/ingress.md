# Ingress

* 外からServiceへのaccessを処理するobject
  * load balancing, TLS termination
* ingress controllerの存在が前提
  * ingressだけ作っても意味がない
* LoadBalancerと違い、k8s component
* Ingress用にNodePort(LoadBalancer)は必要
* Ingress resourceに対応するresource
  * cluster外にcloud porividerがload balancerをたてる場合
  * cluster内にroutingを行うPod(Serviceも?)をたてる場合

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  # https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class
  # ingress-controllerが自身が管理するresourceかどうかの判定に利用
  ingressClassName: "nginx"
  tls:
    - hosts:
        - ymgyt.io
      secretName: ymgyt.io-secret-tls
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

## ALB

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tinypod
  namespace: tinypod
  annotations:
    # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/annotations/#authentication
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/tags: env=staging
    alb.ingress.kubernetes.io/target-type: instance
    # ALB ListenerのAuthenticationにcognitoを指定する場合
    alb.ingress.kubernetes.io/auth-type: cognito
    # cognitoを利用する場合の設定
    alb.ingress.kubernetes.io/auth-idp-cognito: '{"userPoolARN":"arn:aws:cognito-idp:ap-northeast-1:111122223333:userpool/xxx", "userPoolClientID":"XxxxYyyy", "userPoolDomain": "my-domain"}'
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: 'ACM-Cert-ARN'
    # 複数ingressがある場合でも、一つのALBにmergeされる
    alb.ingress.kubernetes.io/group.name: ingress-a
spec:
  rules:
  - http:
      paths:
      -  path: /
         pathType: Prefix
         backend:
           service:
             name: tinypod
             port:
               number: 80
```

* alb controllerを通してALBを作成するIngress
* annotationsでALBの各種設定をおこなう

### Ingress Group

`alb.ingress.kubernetes.io/group.name`が同じIngressは裏側で一つのALBにmergeされる。 

https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.3/guide/ingress/annotations/#group.name

## Routing rules

```yaml
spec:
  rules:
    # http://ymgyt.ioというアクセスに対して
    - host: app.ymgyt.io
      http:
        paths:
          # どのServiceにforwardingするかの設定
          - path: /api/v1
            backend:
              serviceName: app-api-v1-service
              servicePort: 8080
          - path: /api/v2
            backend:
              serviceName: app-api-v2-service
              servicePort: 8080
    - host: analytics.ymgyt.io
      http:
       paths:
         - backend:
             serviceName: analytics-service
             servicePort: 8080
```

* hostごとのroutingと当該hostのpathごとのroutingを定義できる

## TLS

```yaml
spec:
  tls:
    - hosts:
        - ymgyt.io
      secretName: ymgyt.io-secret-tls
```

`spec.tls`を設定するとingressに`https`でアクセルできるようになる?

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ymgyt.io-secret-tls
data:
  tls.crt: base64-encoded-cert
  tls.key: base64-encoded-key
type: kubernetes.io/tls
```
