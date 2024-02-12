# nushell closure

## errorを無視したい

```nu
  do -i { ps | where name =~ "synd_api$" | first | kill $in.pid }
```

* `do -i`でclosureを実行するとerrorを無視してくれる
