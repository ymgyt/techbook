# ln

## 作成


```shell
# 基本は絶対path
ln -s <参照されるfile> <作成されるsymlinkのpath>

# 相対pathで作成する場合
# ln コマンドをうつ場所からの相対ではなく、rootは作成されるsymlinkとした相対path
ln -s <symlinkfileをrootにした相対paht> <作成されるsymlinkのpath>
```

## 削除

link先でなくsymlink file自体を削除する

```shell
ls
# current_release.yml -> ./releases/2017_10.yml

unlink current_release.yml
```
