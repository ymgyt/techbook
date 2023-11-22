# builtins

## one

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