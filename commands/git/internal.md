# Object Store

gitが`.git`に保持しているデータ構造について。

* `.git/objects`配下でkey value storeを保持している
  * commitやfile情報はすべてここに格納されている


## Object

gitがobject storeで管理しているのは以下

* blob
  * 個々のfileの実体
* tree
  * 1 directoryの情報。木構造でdirectory treeを表現
* cocmmit
  * 親commitの情報を保持する
  * tree objectのid(参照)を保持する
    * これがあるから、commitをcheckoutできる
* tag
  * annotated tagで、lightweight tagは格納されない


## Index

* 実体はbinary dataで`.git/index`にある
* 別名 staging directory


## Branch

* commitへの参照
