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

* `VAULT_ADDR`にcluster urlが入っている前提

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
