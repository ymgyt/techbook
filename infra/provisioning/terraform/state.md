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

### S3

```hcl
terraform {
  backend "s3" {
    bucket  = "terraform-state"
    key     = "path/to/terrafrom.tfstate"
    region  = "ap-northeast-1"
    profile = "my-profile"

    # lockする場合のdynamodb
    dynamodb_table = "dynamo_table_foo"
  }
}
```

通常は`main.tf`の`backend` blockに定義する

### Migrate local to remote

まずlocal stateから初めて、remote stateへ切り替える方法

backend block書いてから、`terraform init -migrate-state`を実行する。  
terraformがlocalからremoteへの移行を察してくれる。
移行後は`terrafrom.tfstate`は削除できる

  