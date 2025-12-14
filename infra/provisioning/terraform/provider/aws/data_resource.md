# AWS Provider

## Data

### aws_region

* providerで指定したregionを参照できる

```hcl
data "aws_region" "now" {}

# debug
aws_region = {
  "description" = "Asia Pacific (Tokyo)"
  "endpoint" = "ec2.ap-northeast-1.amazonaws.com"
  "id" = "ap-northeast-1"
  "name" = "ap-northeast-1"
}
```

## aws_caller_identity

account関連の情報

```hcl
data "aws_caller_identity" "now" {}

# debug
aws_caller_identity = {
  "account_id" = "123456789012"
  "arn" = "arn:aws:iam::123456789012:root"
  "id" = "123456789012"
  "user_id" = "123456789012"
}
```

resourceやsource codeにaccount id書かなくてよくなるのでpublic repoで便利かも

## arn

ARNをparseしてくれる

```hcl
data "aws_arn" "db_instance" {
  arn = "arn:aws:rds:eu-west-1:123456789012:db:mysql-db"
}

# debug
aws_arn = {
  "account" = "123456789012"
  "arn" = "arn:aws:rds:eu-west-1:123456789012:db:mysql-db"
  "id" = "arn:aws:rds:eu-west-1:123456789012:db:mysql-db"
  "partition" = "aws"
  "region" = "eu-west-1"
  "resource" = "db:mysql-db"
  "service" = "rds"
}
```

## Avaiablity zone

* 利用できるazを取得できる
* local zoneを除外したりできる

```hcl
data "aws_availability_zones" "available" {
  # exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
```

## Ip range

serviceやregionに応じたip rangeを取得できる
