# Data Strucutre

## 追加

### prepend, append

```nu
 [1 2] | prepend 0
╭───┬───╮
│ 0 │ 0 │
│ 1 │ 1 │
│ 2 │ 2 │
╰───┴───╯

 [1 2] | append 3
╭───┬───╮
│ 0 │ 1 │
│ 1 │ 2 │
│ 2 │ 3 │
╰───┴───╯
```

* prependは引数をinputの先頭に追加する
* appendは引数をinputの最後に追加する