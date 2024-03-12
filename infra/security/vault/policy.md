# Vault Policy

Plicyはpathとoperationに対するgrant or forbidを宣言する方法。


```
# Grant 'create', 'read' and 'update' permission to paths prefixed by 'secret/data/test/'
path "secret/data/test/*" {
  capabilities = [ "create", "read", "update" ]
}

# Manage namespaces
path "sys/namespaces/*" {
   capabilities = [ "create", "read", "update", "delete", "list" ]
}
```

* 適用範囲はpathのprefix
  * most specific defined plicyが利用される
* Policyはnamespaceに紐づく
* `hcp-root` policyはadmin tokenと紐づいているのでeditしない

## 必要なpolicyの確認方法

```sh
vault kv put -output-policy xxx k=v
```

* `-output-policy`を付与すると当該操作に必要なpolicyを教えてくれる


## Capabilities

* `create`: 存在しないresourceを作成
* `read`: read
* `update`: 既存resourceの更新
* `patch`: 既存resourceの一部更新
* `delete`: 削除
* `list`: directoryのlist
* `deny`: 明示的なdeny
* `sudo`: よくわかっておらず

| REST Method	| Capability     |
| ---         | ---            |
|  GET	      | read           |
| PATCH	      | patch          |
| POST	      | create, update |
| PUT	        | create, update |
| DELETE	    | delete         |
| LIST	      | list           |

capabilitiesを設定するには  
実施したい操作に対応するAPIを確認してそのMethodに紐づくcapabilityを設定することになる


## Templated policy

Userのgithub username配下のpathに権限付与したいみたいなusecaseに対応できる。  

`vault list identity/entity/name` で具体的に参照できる情報確認できる

## Recipe

### KV v2

* mount先が`secret`という前提。
* `vault kv get secret/app/foo`とした場合、policyのpathには`secret/data/app/foo`と書く必要がある
  * secret get時の`Secret Path`に書いてある

#### Read only

```hcl
path "secret/data/xxx/+/dev/*" {
  capabilities = ["read"]    
}

path "secret/metadata/xxx/+/dev/*" {
    capabilities = ["read","list"]
}
```

* `list`は`secret/metadata/` 配下に指定することが必要

#### Lifecycle

特定のpath以下でなんでもできるようにするには以下

```hcl
path "secret/data/xxx/*" {
  capabilities = [
    "create","update","patch",
    "read", "list", 
    "delete",
  ]
}

# For soft delete
path "secret/delete/xxx/*" {
    capabilities = ["update"]
}

# For undelete
path "secret/undelete/xxx/*" {
  capabilities = ["update"]    
}

# For destroy
path "secret/destroy/xxx/*" {
  capabilities = ["update"]    
}

path "secret/metadata/xxx/*" {
  capabilities = [
    "create","update","patch",
    "read", "list", 
    "delete",
  ]
}
```

* `secret/{data,metadata,delete,undelete,destroy}`を意識して設定する必要がある

### GUI

https://github.com/jeffsanicola/vault-policy-guide#gui-friendly-policies


### Admin

TODO...
