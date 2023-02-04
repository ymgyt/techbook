# Vault-K8s

## Memo

* Podのannotationにvaultとの接続情報を書く
* VaultがMutating admissionのphaseでpodにsecretをなんらかの方法でinjectする
* Kubernetes側のsecretとは別の機構を用いることになる