# Submit Patch

## Memo

```sh

git format-patch -3 HEAD
git format-patch --cover-letter -3 HEAD
```

* coverletter
  * `[PATCH 0/N]` から始まる
  * これ自体はpatchではない
