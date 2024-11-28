# ssm

* AWS System Manage  
  * 元はAmazon Simple System Managerだったので、ssmと言われている


## EC2へのsession manager 接続

* Amazon SSM Session Manager Pluginが必要
  * nixでは`ssm-session-manager-plugin`(`session-manager-plugin`)

```sh
# EC2 Instance IDを指定して接続
aws ssm start-session --target i-aaabbb0001111
```

### SSH接続

各種toolと連携する際はssh 接続できるとssmを意識せずに透過的に利用できる

```ssh
# HostをinstanceIDで指定するので、雑にwildcard指定
# ssm の credential(profile) は必要に応じて修正する
host i-* mi-*
    IdentityFile path/to/key
    User ec2-user
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"  
```

```sh
ssh <instance-id>
```

* ssm は`ssm-user` でloginしている?
* ssh は`ec2-user` でloginする
