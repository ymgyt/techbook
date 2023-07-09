# Secret engine

## KV v2

* secretは<mount>/data/ 以下に格納される

### Policy

```hcl
path "secret/data/aaa/bbb/*" {
  capabilities = ["read", "list"]
}
```

これで
* `vault kv get secret/aaa/bbb`
* `vault kv get -mount=secret aaa/bbb`

ができる
