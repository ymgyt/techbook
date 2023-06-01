# Builtin

bashのbuildin

## type

`type name...`で引数のnameの種別(alias, function, builtin, file)等を表す

```sh
type type
type is a shell builtin
```

## command

```sh
command time xxx
```

* shellのfunctionを無視してbuiltinか`PATH`からのbinaryのみを実行する