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
