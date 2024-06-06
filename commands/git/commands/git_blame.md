# git blame

## 特定のcommitを無視する

* formatterを適用したりするcommitを無視したい場合がある
* `.git-blame-ignore-revs` fileを作成する
  * file名はgitのconfigで変えられるが、この名前だとgithubがrespectしてくれる

```text
# Apply formatter
79ca0f87bb69b9aa9e093a41c5667251f86c56fc
```

