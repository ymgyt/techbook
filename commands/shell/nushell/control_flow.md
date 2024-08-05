# Control flow

## if 

### if null

```nu
def main [filter?: string] {
  let unreferenced = if ($filter == null) {
    "delete"
  } else {
    "ignore"
  }
}
```

* `$var == null`

### if (expression)

```nu
if ($line | str starts-with 'typo> error: ' ) { }
```

* `if (expression)`

### 空チェック

```nu
 if ($list | is-not-empty) {
  let item = $list | first
}
```

## errorを無視

```nu
do -i { somecommand } | lines
```

* pipeは`{ }`の外に書くらしい

## loop

### each


```nu
'[1, 2, 3, 4, 5]'
| from json
| each { |x| $x * 2 } # each { $in * 2}
```

* 暗黙的に`$in` にbindされるから、変数(`|x|`)を省略したければできる
