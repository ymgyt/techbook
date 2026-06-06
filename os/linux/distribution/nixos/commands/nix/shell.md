# nix shell

指定したpackageが使える状態でshellを起動する。

```sh
# 最新のgit repositoryを参照している
nix shell github:edolstra/dwarffs --command dwarffs --version

# よりreproducible
nix shell github:edolstra/dwarffs/cd7955af31698c571c30b7a0f78e59fd624d0229 ...
```

## nix developとの違い

derivation関連には関与せずに指定されたpackageの`bin`を`PATH`に追加するだけ
