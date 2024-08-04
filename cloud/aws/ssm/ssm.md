# ssm

* AWS System Manage  
  * 元はAmazon Simple System Managerだったので、ssmと言われている


## EC2へのssh接続

* Amazon SSM Session Manager Pluginが必要
  * nixでは`ssm-session-manager-plugin`(`session-manager-plugin`)

```sh
# EC2 Instance IDを指定して接続
aws ssm start-session --target i-aaabbb0001111
```
