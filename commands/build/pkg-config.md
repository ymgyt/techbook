# pkg-config

library `aaa`のheader fileが`/usr/local/include/aaa`に保存した場合  
`gcc -I /usr/local/include`でincludeのpathを指定する必要がある。  
環境によって、includeのpathが変わるとbuild scriptを修正する必要がある。  
そこで

```sh
pkg-config aaa --cflags 
-I /usr/local/include
```

のようにoption解決layerを設けたのがpkg-config

```sh
gcc `pkg-config aaa --cflags` ...
```

のように書ける。  
pkg-configは設定file(`.pc`)を`PKG_CONFIG_PATH`に探しにいく。  
defaultは`/usr/lib/pkgconfig`
