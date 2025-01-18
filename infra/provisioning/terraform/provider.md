# Provider

```hcl
terraform {
  required_version = ">= 1.4.6"

  required_providers {
    vault = {
      version = ">= 3.15.2"  
    }
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```


* `main.tf`に書く
* `terraform version`で現在のprovider含めたversionがわかる
* version constraintsの書き方はdoc参照
  * https://developer.hashicorp.com/terraform/tutorials/configuration-language/versions#terraform-version-constraints
  * `>= 1.2.3`は1.2.3よりgrater
  * `~>` はpatchのみあげられる

* `source`は`host/organization/type`で定義する
  * hostが省略されると`registry.terraform.io`
  * organizationが省略されると`hashicorp`
  * versionが省略されるとlatest
  * 結果的に定義されなければhashicorpのproviderがつかわれる設計になっている

## Multiple provider

```hcl
provider "aws" {
  region = "us-east-2"
  alias  = "region_1"
}

provider "aws" {
  region = "us-west-1"
  alias  = "region_2"
}

resource "aws_instance" "region_1" {
  provider = aws.region_1
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
}

resource "aws_instance" "region_2" {
  provider = aws.region_2
  ami           = "ami-01f87c43e618bf8f0"
  instance_type = "t2.micro"
}
```

resourceのregionを分けたいとき等に使える
 
## aws

```hcl
provider "aws" {
  region = "us-east-2"
  # 利用するprofile
  profile = var.profile

  allowed_account_ids = ["<target_account>"]

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner     = "team-foo"
      ManagedBy = "Terraform"
    }
  }
}
```

* `default_tags`で共通で付与したいtagを指定できる


## Providerの更新(upgrade)

* 現在のproviderのversionは `.terraform.lock.hcl` に書いてある
* `terraform init -upgrade` 
  * version constraintで互換性のある最新まであがる `~> 4.0` で現在が4.0.0の場合に最新(4.7.1等)まで上がる
