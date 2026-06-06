# git rebase

```shell
# ３つのcommitを変更対象にする
git rebase -i HEAD~3
```

* 古いcommitが先頭にくる
* squashは当該commitがなくなりpreviousにmergeされる
* `git rebase --abort`すると、rebaseの作業をなかったことにできる
* 競合が発生したら、解消して、git addして、`git rebase --continue`
  * conflict解消時にmain, featureどちらかのcommitを利用したい場合
    * `git checkout --theirs` featureの変更の適用
    * `git checkout --ours` mainの変更を適用
    * `git rebase main`としているが、oursがmainなので注意
* pushする際にforceが必要なら、`git push --force-with-lease`でやる
