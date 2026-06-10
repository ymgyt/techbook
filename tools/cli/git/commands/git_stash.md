# git stash

## Usage

```shell
# untrackedなfileもstaskする
# 引数指定しない場合は push
git stash [-u|--include-untracked]

# pathを指定。全部stash したくない場合
git stash push -- path/to/a.txt path/to/b.txt

# stashを削除する
git stash drop

# stashにmessageを付与
git stash push -m 'message'
```
