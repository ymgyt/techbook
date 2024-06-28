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
