# Driver Debug

## defineの展開後をみたい

`V=1`でmoduleをbuildする

```make
modules:
	$(MAKE) -C $(KDIR) M=$(PWD) V=1 modules
```

gccの実行ログを探す
```sh
gcc -Wp,-MMD,./.devone.o.d
# ...
-c -o devone.o devone.c
```

* `-c -o devone.o` を探して消す
* `-E -DP -P` をつける

```sh
gcc -Wp,-MMD,./.devone.o.d
# ...
-E -DP -P devone.c
```
