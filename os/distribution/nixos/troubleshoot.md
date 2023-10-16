# Nix Troubleshoot

## MacでTLS関連のbuildが失敗する

以下を依存に追加してみる

```text
devShells.default = pkgs.mkShell {
  packages = with pkgs; [
    darwin.apple_sdk.frameworks.Security
  ];
}
```

* `darwin.apple_sdk.frameworks.*`を試してみる