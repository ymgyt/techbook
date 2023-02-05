# rebase

```console
# ３つのcommitを変更対象にする
git rebase -i HEAD~3
```

* 古いcommitが先頭にくる
* squashは当該commitがなくなりpreviousにmergeされる
* `git rebase --abort`すると、rebaseの作業をなかったことにできる
* 競合が発生したら、解消して、git addして、`git rebase --continue`
* pushする際にforceが必要なら、`git push --force-with-lease`でやる
