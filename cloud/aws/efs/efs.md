# EFS

## Access制御

以下の機構によってアクセスを制御できる

* SecurityGroup
* IAM
* EFS Access Point

### IAM Policy

* `elasticfilesystem:ClientMount`
* `elasticfilesystem:ClientWrite`
* `elasticfilesystem:ClientRootAccess`


#### Resource Based

* Resource(EFS)側にpolicyを付与することもできる
