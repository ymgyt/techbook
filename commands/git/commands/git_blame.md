# git blame

## 特定のcommitを無視する

* formatterを適用したりするcommitを無視したい場合がある
* `.git-blame-ignore-revs` fileを作成する
  * file名はgitのconfigで変えられるが、この名前だとgithubがrespectしてくれる
* defaultではrespectされない場合がある?
  * `git config blame.ignoreRevsFile .git-blame-ignore-revs`
  * [Git docs](https://git-scm.com/docs/git-blame#Documentation/git-blame.txt---ignore-revs-fileltfilegt)
* githubではdefaultで`.git-blame-ignore-revs`がrespectされる
  * https://docs.github.com/en/repositories/working-with-files/using-files/viewing-a-file#ignore-commits-in-the-blame-view

```text
# Apply formatter
79ca0f87bb69b9aa9e093a41c5667251f86c56fc
```

