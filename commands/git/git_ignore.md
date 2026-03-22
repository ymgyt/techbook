# ignore file

```sh
# .gitignoreと同じ階層のdir/file をignore
/foo

# .gitignoreと同じ階層のdir をignore
/foo/

# ./dir/
# ./sub/dir をignore
foo/

# ./foo
# ./foo/
# ./sub/foo
# ./sub/foo/ をignore
foo
```

* 末尾の`/`でdirを表現
* 先頭の`/` で.gitignoreを起点にした絶対path指定
