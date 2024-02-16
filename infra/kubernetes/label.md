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

## Conventions

| Key                            | Description      | Example |
| ---                            | ---              | ---     |
| `app.kubernetes.io/name`       | appの名前        | `mysql` |
| `app.kubernetes.io/instance`   | appのuniqueな識別子 | `mysql` |
| `app.kubernetes.io/version`    | appのversion     | `1.2.3` |
| `app.kubernetes.io/component`  | いまいちわからず | ""      |
| `app.kubernetes.io/managed-by` | 管理しているtool | `helm`  |
| `kubernetes.io/hostname`       | nodeのhostname   | `foo`   |

* `name`はuniqueは求められない
* `instance`は同一namespaceに異なるwebsite用に複数のnginxがあるようなケースで識別子として用いる

* `kubernetes.io/hostname` kubeletがnodeに付与する。topology spread constraintsでも参照される


## 参考

* [Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

* [Well-Known Lbels, Annotations](https://kubernetes.io/docs/reference/labels-annotations-taints/)
