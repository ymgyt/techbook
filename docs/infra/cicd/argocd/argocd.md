# ArgoCD

## References

* https://blog.mosuke.tech/entry/2021/04/13/argocd/

## 構築手順メモ


```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.2.2/manifests/install.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argocd login <ARGOCD_SERVER> --insecure

GITHUB_USER=xxx
GITHUB_TOKEN=yyy
argocd repo add https://github.com/ymgyt/argocd-handson-gitops --username ${GITHUB_USER} --password ${GITHUB_TOKEN}

 argocd app create tinypod --repo https://github.com/ymgyt/argocd-handson-gitops --path tinypod/overlays/staging --dest-server https://kubernetes.default.svc --dest-namespace tinypod
 
 argocd app set tinypod --sync-policy automated
```



### tool

```shell
VERSION=v2.2.2
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

mac
```shell
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.2.2/argocd-darwin-amd64
chmod +x /usr/local/bin/argocd
```
