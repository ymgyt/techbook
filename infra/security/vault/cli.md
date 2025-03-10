# Vault cli

## Install

https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install

```sh
mkdir -p $GOPATH/src/github.com/hashicorp && cd $_
git clone https://github.com/hashicorp/vault.git
cd vault

make bootstrap
make dev

vault -h
```

## Usage


通信するAPI endpointを指定するには以下の方法がある。

* 環境変数 `VAULT_ADDR`
* `-address` flag


```sh
# Check status
vault status

# With amind token, authenticate user/machine
vault login

# View the current token configuration
vault token lookup
```

## Namespace

* 環境変数`VAULT_NAMESPACE`か`-namespace`,`-ns`でnamespaceを指定できる
  * flagが優先される

### Create

```shell
export VAULT_NAMESPACE=admin
vault namespace create education

vault namespace create -namespace admin/education training
```

* `admin/education` namespaceが作成される
* `-namespace`で指定できる

### List

```shell
vault namespace list
vault namespace list -namespace=admin/education
```

## Login

### Github

```sh
# Github
 vault login -method=github token=$(cat ~/.credentials/gh_pat_read_org)
```

* classic patの`read:org` scopeが必要


## KV

```sh
export VAULT_NAMESPACE=admin

# Enable kv
vault secrets enable -path=secret kv-v2

# Put
vault kv put secret/test/webapp api-key="ABCDEFG9876"

# Get
vault kv get secret/test/webapp
```

### Get


```sh
# access to secret/data/aaa/bbb
vault kv get secret/aaa/bbb

vault kv get -mount=secret aaa/bbb
```

* 暗黙的に`data`が入るのでややこしい
  * policy側はこのdataにawareである必要がある
* kv v2が`secret`にmountされている前提

### Put

Putはsecretを全て置き換える

#### Find and stdin

Valueはfileやstdinから渡すこともできる。  
Fileを指定する場合はfile pathの先頭に`@`を付与する。

```sh
vault kv put secret/test key=@/tmp/data.json
```

Stdinから渡す場合は`-`を指定。  

```sh
echo "secret123" | vault kv put secret/test key=-
```


#### Cas

`vault kv put`は既存のkeyの有無に関わらず新しいkey valueをセットします。また現在のversionが特定のversionの場合に限って新しいsecretをセットしたい場合があります。  
そのようなユースケースでは`-cas` flagを利用できます。場面に応じて以下の値をセットしてください。  

* `-cas=-1`: default値、書き込みは必ず成功する
* `-cas=0`: secretが存在しない場合のみ、書き込みが成功する
* `-cas=n(n >= 1)`: 現在のsecretが指定されたversionと一致する場合のみ書き込みが成功する 

```sh
vault kv put -cas=0 secret/test initial-secret=123
```

### Patch

partial updateにはpatchを利用する
```sh
vault kv patch secret/lawgue/sre/dev/test key-2=value-2
```

### Delete

Vaultはsoft deleteをサポートしています。

#### Soft delete

```sh
vault kv delete secret/test

versionを指定するには、`-versions` flagを利用します。

```sh
vault kv delete -versions=3 secret/test
```

`vault kv delete`を実行すると、当該versionをdelete状態とし、`deletion_time` timestampを付与します。

deleteを取り消すには`undelete`コマンドを実行します。  

```sh
vault kv undelete -versions=3 secret/test
```

#### Permanently delete

Storage上からsecretを削除するには`destroy`コマンドを実行します。  

```sh
vault kv destroy -versions=3 secret/test


Secretの全てのversionを削除するには以下のコマンドを実行します。  

```sh
vault kv metadata delete secret/test
```


## Policy


### Create

```shell
vault policy write tester - << EOF
# Grant 'create', 'read' and 'update' permission to paths prefixed by 'secret/data/test/'
path "secret/data/test/*" {
  capabilities = [ "create", "read", "update" ]
}

# Manage namespaces
path "sys/namespaces/*" {
   capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOF
```

### List and Read

```shell
vault policy list

vault policy read tester
```

### Print policy requirement(capabilities)

ある操作を行うのに必要なpolicyのcapabilitesを確認できる

```sh
vault kv put -output-policy secret/test key1=value1
```

## Auth method

### AppRole

```shell
# Enable
vault auth enable approle

# Create webapp role with tester policy attached
vault write auth/approle/role/webapp \
  token_policies="tester" \
  token_ttl=1h token_max_ttl=4h

# Read RoleId
vault read auth/approle/role/webapp/role-id

# Generate SecretId
vault write -force auth/approle/role/webapp/secret-id
```

## Audit

```
# Enable stdout audit
vault audit enable -path=stdout file file_path=stdout 

vault audit list
```

## Vaultの初期化(Unseal)

vaultは起動した状態ではAPIとして機能しないsealedという状態にあります。  
Sealedという状態を解除するunsealを行うために以下のコマンドを実行します。  
実行時はvaultのPodにkubectl execを行ってlocalhostで通信している想定です。  

```sh
vault operator init
Unseal Key 1: AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Unseal Key 2: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
Unseal Key 3: CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
Unseal Key 4: DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
Unseal Key 5: EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
Initial Root Token: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.
Vault does not store the generated master key. Without at least 3 keys to
reconstruct the master key, Vault will remain permanently sealed!
It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

`vault operator init`を実行するとunseal keyとroot tokenが出力されます。  
このunseal keyは運用担当者が分散して保管します。 

次にunsealを行います。  

```sh
vault operator unseal
Unseal Key (will be hidden): 
```

`vault operator unseal`実行後に上記unseal keyのいずれかを入力します。  
この操作を3回それぞれ異なるunseal keyで行います。  

```sh
vault status | rg Sealed
Sealed          false
```

`Sealed`がfalseとなっていれば成功です。  
Unsealが成功したのちにlocal等から

```sh
export VAULT_ADDR=https://vault.example.com
vault login
```

を実行し、`Initial Root Token: XXXXXXXXXXXXXXXXXXXXXXXXX`を入力します。  
これでvaultを操作できる状態となります。
