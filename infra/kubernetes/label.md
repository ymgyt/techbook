# Label

Labelどうすればいいのか問題

## 仕様

* `-`, `_`, `.`が使える
* `kubernetes.io`,`k8s.io` prefixはreserved
* keyはoptionalでprefixをもてる
  * `/`でseparateする
  * nameは63 characters
  * prefixはDNS subdomain(sub?)
  * prefixなしはuserのprivate用で、tool系は必ずprefixを付与する

## annotationsとの使いわけ

identityに関わらない付加的な情報はannotation。  
分類やquery,filterで利用したい情報はlabel。

## 参考

* [Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

* [Well-Known Lbels, Annotations](https://kubernetes.io/docs/reference/labels-annotations-taints/)
