# function

nuの関数定義。

```nu
def book [ ] {
  hx $"($nu.home-path)/rs/techbook"
}
```

## Recipe

### each

```nu
> ls | each { |it|
    cd $it.name
    make
}
```

* cdは`PWD`を変更するが、これはblockに閉じるので次のeachに影響しない