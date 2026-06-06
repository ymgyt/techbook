# Module

## Visibility and Privacy

```text
Visibility :
      pub
   | pub ( crate )
   | pub ( self )
   | pub ( super )
   | pub ( in SimplePath )
```

* 原則すべてprivate
  * pub traitのassociate itemは例外的にpub
  * pub enumのvariantは例外的にpub

* pub itemにaccessできる場合
  * rootからitemへのmoduleにアクセスできればaccessできる

* private itemにaccessできる場合
  * current module
  * current module descendants(子孫)
    * rootにprivate moduleを用意すると、crate内部で利用できるglobal helper moduleを作れる
      * global helper moduleのitemはpubである必要がある
      * 全てのmoduleはrootのdescendantsなので、rootのmember(private module)が見える
    * mod testsを書いておくと、childなので、実装含めてtestできる
