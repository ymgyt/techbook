# Edition

* crateごとに選択する、rustcのどの後方非互換な機能を利用するかの設定
  * appはedition 2024を利用しつつ、lib-aは2018, lib-bは2021ということが可能
  * ecosystemの分断を防ぐ
* `async` keywordのような非互換な機能(async 変数名とconflictする)が追加される際には新しいeditionとして導入される

* editionごとの変更は[The Rust Edition Guide](https://doc.rust-lang.org/edition-guide/editions/)を参照
