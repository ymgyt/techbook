# Expression

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

## 三項演算子

```hcl
resource "foo" "bar" {
  count = var.env == "prod" ? 1 : 0
}
```

