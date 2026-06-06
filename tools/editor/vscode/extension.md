# VSCode Extension

## vsce

* extension を管理するためのcli
* `.vsix` 拡張子のfile がbundle された実体
  * `code --install-extension ./myext-<version>.vsix` で install できる

```sh
# vsix file がbuild される
npx vsce package
```

