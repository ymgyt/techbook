# Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
```

* terraformに必要なproviderの情報を渡すには`terraform.required_provider`を定義する
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