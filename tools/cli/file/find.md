# find

## exec

```sh
# xargsを使った場合のようにある程度まとめてコマンドを実行する
find ... -exec rm -rf {} \+

# 逐次実行
find ... -exec rm -rf {} \;
```
