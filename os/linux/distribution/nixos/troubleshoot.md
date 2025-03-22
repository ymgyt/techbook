# Nix Troubleshoot

## MacでTLS関連のbuildが失敗する

* `ld: framework not found Security`

以下を依存に追加してみる

```text
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    darwin.apple_sdk.frameworks.Security
  ];
}
```

```
buildInputs = [ ] ++ lib.optionals pkgs.stdenv.isDarwin [
  pkgs.libiconv
  pkgs.darwin.apple_sdk.frameworks.Security
];
```

* `darwin.apple_sdk.frameworks.*`を試してみる

## nix管理外のprojectでopensslがbuildできない

```sh
 PKG_CONFIG_PATH=/nix/store/lhgj80qbyazybi5cb6kkxr8f9vj141xq-openssl-3.0.12-dev/lib/pkgconfig/ cargo cl
ippy --all --all-features
```

* `/nix/store/<hash>lopenssl-3.X.Y-dev/lib/pkgconfig`を`PKG_CONFIG_PATH`に指定するとなんとかなる


## llvmのtools(objdump)をinstallしたい

```sh
 nix profile install nixpkgs#llvmPackages_18.bintools

# これが実質llvm-objdump
objdump
```
