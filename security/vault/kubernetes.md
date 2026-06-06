# Vault-K8s

## Kubernetes Auth Method

1. Pod(Service account)からVault(K8s auth method)に認証requestする
2. Vaultからk8sのtoken review apiにrequestを送り、saを検証する
3. saとnamespaceが検証できたら、vaultのroleを紐づける
4. vaultのroleにはpolicyが紐づいており、policyを付与したvault auth tokenをPodに返す
5. Podはそのvualt auth tokenを利用してsecretへアクセスする

## Role

* k8sのroleではなく、vaultのservice accountと複数のpolicyを関連づけるデータ

```sh
vault write auth/kubernetes/role/app \
bound_service_account_names=app \
bound_service_account_namespaces=default \
policies=app-secret \
ttl=24h
Success! Data written to: auth/kubernetes/role/app 

# 確認
vault list auth/kubernetes/role
```

## Vault Secrets Operator

* Custom resource `VaultStaticSecret`の適用とtriggerにしてvaultからsecretを取得してk8sのSecretを作成

### Custom Resource

* `VaultConnection`: vaultの接続情報を保持
* `VaultAuth`: vaultに接続する際のservice accountとvaultのroleを指定
* `VaultStaticSecret`: vault上の取得したいsecret

## Memo

* Podのannotationにvaultとの接続情報を書く
* VaultがMutating admissionのphaseでpodにsecretをなんらかの方法でinjectする
* Kubernetes側のsecretとは別の機構を用いることになる
