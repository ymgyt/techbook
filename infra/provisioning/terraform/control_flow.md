# Control Flow

## count

```hcl
variable "user_names" {
  type = list(string)
  default = ["a", "b", "c"]
}

resource "aws_iam_user" "foo" {
  count = length(var.user_names)
  name = var.user_names[count.index]
}

output "first" {
  value = aws_iam_user.foo[0].arn 
}

output "all" {
  value = aws_aim_user.foo[*].arn
}

# all = [
  # "arn:..."
  # "arn:..."
  # "arn:..."
#]

# moduleにも使える
module "users" {
  source = "path/to/module"

  count = length(var.user_names)
  user_name = var.user_names[count.index]
}
```

* countの数だけresourceが作成される
* `${count.index}`で現在のindexを参照

* 制約
  * inline blockでは参照できない仕様
  * `["a", "b", "c"]`から`["a", "c"]`とした場合、同一性判定はindexでなされるので、c削除、bをupdateという解釈がされてしまう
  * 制約に対処するために`for_each`が導入された
  * hardcodeされた値かvariable,data sourceしか参照できない
    * 他resourceのattributeを参照できない


## for_each

countはresourceのarrayに評価されるがいろいろ問題があるので、map志向のfor_eachが必要になった

```hcl
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  for_each = <COLLECTION>

  foo = each.key
}
```

```hcl
resource "aws_iam_user" "foo" {
  for_each = toset(var.user_names)
  name = each.value
}

output "all_users" {
  value = aws_iam_user.foo
}

// all_users = {
//    "a" = {
//      "arn" = "..."
//    }
//    "b" = {
//     "arn" = "aaa"
//   }
// }

// arnのlistにするには
output "all_arns" {
  value = values(aws_iam_user.foo)[*].arn
}
```

* `for_each`に指定できるのはsetかmap
* resource定義の中で`each.key`,`each.value`が参照できる
* for_eachで作成されたresourceはkeyがfor_eachのkeyで値が作成されたresourceのmapになる(countはarray)
  * `<resource>.<identifier>[key].<attribute>` で参照する
    * `aws_instance.example[foo].id`

### inline

```hcl
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

resource "aws_autoscaling_group" "example" {

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
```

* inlineをiterateするには`dynamic`を使う

## 三項演算子

```hcl
resource "foo" "bar" {
  count = var.env == "prod" ? 1 : 0
}
```


## for expression

pythonぽい
```
[for <item> in <list> : <output>]  

[for <key>,<value> in <map> : <output>]
```

```hcl
output "upper_names" {
  value = [for name in var.names : upper(name)]
}

output "foo" {
  value = [for name,role in var.map_foo : "${name}_${role}"]
}
```

mapを出力することもできる

```
{for <item> in <list> : <out_key> => <out_value> }

{for <key>,<value> in <map> : <out_key> => <out_value> }
```

```hcl
output "upper_roles" {
  value = {for name, role in var.maps : upper(name) => upper(role) }
}
```

## Condition

特定の場合にresourceを作成したり、parameterを変えたりしたい。  
conditionの場合はcountの1/0制御がシンプルでよさそう。

### count

```hcl
variable "enable_foo" {
  type = bool
}

resource "foo_bar" "x" {
  count = var.enable_foo ? 1 : 0
}
```

* countに0を指定することで擬似的にresourceを作成しない


### for_each


```hcl
dynamic "tag" {
  for_each = {
    for key, value in var.custom_tags:
    key => upper(value)
    if key == "Name"
  }

  content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
  }
}
```

* for_eachに与えるcollectionの生成にifをかませる
  * 空のcollectionなら結果的にresourceが作られない
