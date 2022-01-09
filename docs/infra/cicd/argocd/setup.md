# ArgoCD Setup

```shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.2.2/manifests/install.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argocd login <ARGOCD_SERVER> --insecure

GITHUB_USER=xxx
GITHUB_TOKEN=yyy
argocd repo add https://github.com/ymgyt/argocd-handson-gitops --username ${GITHUB_USER} --password ${GITHUB_TOKEN}

argocd app create tinypod \
  --repo https://github.com/ymgyt/argocd-handson-gitops \
  --path tinypod/overlays/staging \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace tinypod \
  --reivsion main \
  --sync-policy automated
```
