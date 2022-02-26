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
