# sops

## `.sops.yaml`

```yaml
creation_rules:
  - path_regex: \.sops\.yaml$
    kms: <kms-arn>
    encrypted_regex: ^(data|stringData)$
```

## Kubernetes Secret

1. Secretを生成する

素(base64) のsecretを作る。これはcommitしない

```sh
(
  kubectl create secret generic my-secret
    --namespace ns
    --from-file=key1=path/to/key.pem
    --dry-run=client -o yaml
    out> path/to/secret.sops.yaml
)
```

2. in place で暗号化する

```sh
sops -e -i path/to/secret.sops.yaml
```

これにより、sopsで暗号化された、Secret manifestになり、commitできる
