# builtins

## 複数 expression

### one

```hcl
output "neo_cloudwatch_policy_arn" {
  value = one(concat(
    aws_iam_user_policy_attachment.neo_cloudwatch_full_access[*].policy_arn,
    aws_iam_user_policy_attachment.neo_cloudwatch_read_only[*].policy_arn
  ))
}
```

* listから1つを選択する
  * 空の場合はnull
  * 1 elementの場合はそれ
  * 2以上の場合はerror
* 排他的な条件によりどれか一つだけが有効という意図を表現できる

### try

```sh
try(local.foo.bar, "fallback")
```

* 複数expressionを評価して、最初にerrorではないものを利用する



## templatefile

```hcl
resource "aws_launch_configuration" "example" {
  user_data       = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
erver_text = var.server_text
  })
}
```

* 相対pathはterraformのcwdなのでmodule awareにする


## coalesce

* 可変超引数で最初にnull,emptyでないものを返す

```sh
> coalesce("", "a")
a
```

## try

* 引数のexpressionを順番に評価して、errorでないものを返す
  * 存在しない場合があるfieldを参照する際に有用

```sh
> local.foo
{
  "bar" = "baz"
}
> try(local.foo.bar, "fallback")
baz
> try(local.foo.boop, "fallback")
fallback
```

## Collection関連

## keys

map,objectのkeyをlistで返す

```hcl
locals {
  public_subnets = {
    "ap-northeast-1a" = {
      "cidr" = "10.0.1.0/24"
    },
    "ap-northeast-1c" = {
      "cidr" = "10.0.2.0/24"
    },
  }

  foo = keys(local.public_subnets)[0] # => "ap-northeast-1a"
}
```

## concat (listの結合) 

```sh
> concat(["a", ""], ["b", "c"])
[
  "a",
  "",
  "b",
  "c",
]
```

* `distinct(concat())` で重複を排除できる

## References

* [Terraform Functions and Expressions Explained](https://build5nines.com/terraform-functions-and-expressions-explained/?mkt_tok=ODQ1LVpMRi0xOTEAAAGVpBvNRfPKaPxmyZtKzvfZ7nkcbKwo8Brcwph0cfSOxsQUTsPgFjlluhMQxKhraSxc68A4YMKJp9jrkpeNI7GNOVUgKlCRvmloHcSZPnM45Sy3-1M)
* [Using the Terraform ‘merge’ Function](https://build5nines.com/using-the-terraform-merge-function/)
