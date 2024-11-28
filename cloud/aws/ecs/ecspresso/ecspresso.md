# ecspresso

* ECSのTask, Service関連のリソースを操作するコマンド


## Fileの処理順序

1. ecspresso内のjsonnetで`.jsonnet`を処理してjsonにする
2. json, yamlをtemplate としてgotemplateで処理して、json, yamlにする
3. json, yamlを設定fileとして処理を実行

* jsonnetはtemplateとして扱われないので、jsonnetとして有効に書かないといけない
