# Control flow

## if null

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
