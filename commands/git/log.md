# git log

## 特定ファイルのcommit履歴を確認する

```shell

git log -p path/to/file.txt

# 何が変わるかわかっていない
git log --word-diff -p path/to/file.txt

# authorの指定もできる
git log --author ymgyt --word-diff -p path/to/file.txt

# 起点から過去3回
git log --word-diff <commit> -n 3 -p path/to/file.txt
```
