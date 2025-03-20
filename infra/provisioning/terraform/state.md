# Terraform State

```hcl
resource "aws_instance" "foo" {
  ami = "xxx"
  instance_type = "t2.micro"
}
```

この`foo` resourceが対応するEC2 instanceのidをstateに保持している。  
instance idをstateに保持できているから、差分や更新を行える

* stateは`terraform.tfstate`という1 fileに記録される
  * 複数人で共有する場合、競合の危険があるのでlock機構が必要になる

## Backend

[backend](./backend.md) 参照

### Migrate local to remote

まずlocal stateから初めて、remote stateへ切り替える方法

backend block書いてから、`terraform init -migrate-state [-backend-config=backend.tfbackend]`を実行する。  
terraformがlocalからremoteへの移行を察してくれる。
移行後は`terrafrom.tfstate`は削除できる


## Stateの分離

productionとstagingを同じterraform.tfstateで管理したくない。のでなんらかの方法でstateを分けたいという問題意識。

### Workspace

* worksapceごとに`env` directory配下に新しいterrafrom.tfstateが生成される
  * stagingなら`path/env/staging/terraform.tfstate`


```hcl
resource "aws_instance" "foo" {
  instance_type = terraform.workspace == "default" ? "tw.medium" : "t2.micro"
}
```

* 一種のglobal変数で、どう分岐させるかは書き方次第
  * state fileの分離という支援をうけれる点が特別
* `terraform.workspace`で現在のworkspaceを判定できる
* state fileは同じbackendに格納されるので、認可上の分離が弱い
* codeをみているだけだと実際にいくつの環境があるのかわからない


### Directory Layout

分離したい環境ごとにdirectoryを分けるアプローチ。  
当然、backendの設定もわかれることになる。

```
.
├── production
│  ├── services
│  │  ├── dependencies.tf
│  │  ├── main.tf
│  │  ├── outputs.tf
│  │  ├── providers.tf
│  │  └── variables.tf
│  ├── storage
│  └── vpc
└── staging
   ├── services
   ├── storage
   └── vpc
```

### `terraform_remote_state`

他のterraform state fileをdata sourceとして参照できる。

1. 被参照側のprojectでoutputを定義する

```hcl
output "address" {
  value = aws_db_instance.foo.address
  description = "foo"
}
```

2. 参照側で参照する

```hcl
data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "bucket"
    key = "path/to/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
```

* `data.terraform_remote_state.db.outputs.address`で参照できる

## 他のRoot moduleのstateを参照する

* `terraform_remote_state` data soruce を利用することで、他のroot moduleのoutputを参照できる

## State操作

```sh
# 特定のresourceのstateを確認
terraform state show foo_xxx.yyy
# for_each のresourceはsingle quoteしておく
terraform state show 'packet_device.worker["example"]'

# stateの一覧を確認
terraform state list
```
