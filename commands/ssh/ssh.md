# ssh

## option

* configで指定できる項目はoptionでも渡せる
```shell
ssh -o IdentitiesOnly=yes

# 利用するssh configを指定
ssh -F path/to/config 
```

## Test Connection

``shell
ssh -T git@github.com
``

## 公開鍵認証を有効にする

対象serverにssh-keyによるloginを有効にする

1. `~/.ssh` directoryを作成する。permissionは`0700`
2. `~/.ssh/authried_keys`を作成する。permissionは`0600`  
3. public keyの内容を貼り付ける。commentは関係ない

## Trouble shoot

### Too many authentication failures

`ssh <user>@<host> -i <key_path>`としているのに、接続できない ssh-add -D にて ssh-agentを一度クリアすると接続できた。 -i で指定した鍵が優先的に利用されるわけではない。  
Server側のsshdの設定 MaxAuthTries (default 6とのこと) の制限をうけている。
`ssh -o IdentitiesOnly=yes` とすることで、ssh-agentを利用しないこともできる

## Configfile

```text
Host bastion
  HostName 192.168.10.10
  Port 22

Host xxx-aaa
  HostName 192.168.10.20
  Port 22
  ProxyJump bastion

HOST *
  User ferris
  IdentityFile path/to/key/file
  ForwardAgent yes
  StrictHostKeyChecking no
```

* 各entryは一致すると適用される。当該設定がなければ適応される。
  * なので下にwildcardを書いておくとdefault設定になる
* `ProxyJump`でbastionを経由できる
