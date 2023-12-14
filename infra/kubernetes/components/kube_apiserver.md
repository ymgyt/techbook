# kube-apiserver

## 起動option

* `--client-ca-file=SOMEFILE` certificate authoritiesを指定する
* `--token-auth-file=SOMEFILE` http headerのAuthorizationで渡せるtokenを指定できる
* `--enable-bootstrap-token-auth` kubeadmが利用するbootstrap tokenの認証を有効にする

### OIDC

* `--oidc-issuer-url` OIDCのprovider URL
  * `https://account.provider.example`を設定すると`https://account.provider.example/.well-known/openid-configuration`にjwtを検証するための公開鍵を探しにいく

### Admission controller

* `--enable-admission-plugins=XXX,YYY`
* `--disable-admission-plugins=ZZZ,AAA`

## Authentication

* apiserverが信頼するOIDC providerは1つまで
* jwtを検証するための公開鍵はapiserverのCAで署名されていないといけない

### 認証に成功すると

requestが認証に成功すると以下の情報をえる

* user name
* UID
* groups
  * 認証されると`system:authenticated`に所属する
  * anonymous userの場合は`system:unauthenticated`に所属する
* Extra


## 設定の確認方法

kube-apiserverの設定方法を確認するにはmaster node上の  
`/etc/kubernetes/manifests/kube-apiserver.yaml`を確認する。

## Requestの処理の流れ

1. Auth
  1.1 Authentication
  1.2 Authorization
2. Mutating Admission
3. Object Schema Validation
4. Validating Admission
5. etcd persistence

## Admission Controller

* kube-apiserverのbinaryに含まれている
* requestをmutateしたりvalidateしたりする
* [一覧](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)
* `kube-apiserver -h | grep enable-admission-plugins`で一覧を確認できる
* [source](https://github.com/kubernetes/kubernetes/blob/master/plugin/pkg/admission/serviceaccount/admission.go)
