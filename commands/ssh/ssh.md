# ssh

## option

* configで指定できる項目はoptionでも渡せる
```shell
ssh -o IdentitiesOnly=yes
```

## Test Connection

``shell
ssh -T git@github.com
``

## Trouble shoot

### Too many authentication failures

`ssh <user>@<host> -i <key_path>`としているのに、接続できない ssh-add -D にて ssh-agentを一度クリアすると接続できた。 -i で指定した鍵が優先的に利用されるわけではない。  
Server側のsshdの設定 MaxAuthTries (default 6とのこと) の制限をうけている。
`ssh -o IdentitiesOnly=yes` とすることで、ssh-agentを利用しないこともできる
