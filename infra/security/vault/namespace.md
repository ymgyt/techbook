# Vault namespace

A vault namespace enables teams, organizations, or applications a dedicated, isolated environment.  
Each namespace has its own:

* Policies
* Auth methods
* Secrets engines
* Tokens
* Identity entities and groups

Enterpirse専用機能。  
HCPでは搭載されている。
https://developer.hashicorp.com/vault/docs/enterprise/namespaces

## CLI

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


### Namespace api lock

* namespace単位でlock/unlockというstatusがある
* lockされると`sys/health`等の一部を除いて利用できなくなる
* 部分的に利用を制限したいユースケースで利用できる

