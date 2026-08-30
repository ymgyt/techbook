# readelf

```sh
readelf --all ~/.cargo/bin/rustup

# linkerの確認
readefl --string-dump=.interp foo
```

* `-d | --dynamic | --dynamic-table`: dynamic section
* `-l | --program-header`: program header
* `-h | --file-header`: ELF自体のheader
* `-S | --section-headers | --sections`: section header
* `-s`: symbol table
* `-x N`: N番目のセクションの表示
* `-p | --string-dump`: section のstring表現
  

