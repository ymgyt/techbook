# bundle

## localのgemを利用する

`foo` というgem をlocalに切り替える

```sh
# 有効化
bundle config local.foo /path/to/foo
bundle install

# 元に戻す
bundle config --delete local.foo
```
  
