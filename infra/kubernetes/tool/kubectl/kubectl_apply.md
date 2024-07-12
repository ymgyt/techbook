# kubectl apply

* 実装的にはhttp patch methodを利用している

```shell
kubectl apply -f path/to/object.yaml
```

## 差分の計算

* 差分の計算には3つの要素を参照する
  * localのmanifest( `kubectl apply -f local-manifest`)
  * live object(kubernetes上のetcdに永続化されているobject)
  * annotationに保持されている`kubectl.kubernetes.io/last-applied-configuration`

* 前提
  * applyするlocal manifestにはobjectのすべてのfieldが定義されていない
    * default値であったり、controllerであったり他のcomponentが管理していたりする

* 課題
  * local manifestからあるfieldを削除した場合
    * live objectのそのfieldを削除したいのか、そのままにしたいのか曖昧

* 対応
  * 前回適用時のmanifestを保持しておいて、前回適用時には宣言されているが、今回のlocal manifestには宣言されていないfieldは削除する
  * 前回適用時にも、今回適用するlocal manifestにも宣言されていないfieldは既存をrespectする


| Keyがlocal manifestにある | Keyがlive objectにある | Keyがlast appliedにある | Action |
| ---                       | ---                    | ---                     | ---    |
|  Yes                      | Yes                    | -                       | localの値で更新 |  
|  Yes                      | No                     | -                       | localの値を設定 |
|  No                       | -                      | Yes                     | Keyの値をclear  |
|  No                       | -                      | No                      | なにもせず、既存をrespect  |
  

* まとめ
  * 前回適用時の情報を保持することで、前回あったのに今回はないという不存在を表現している
  * これにより直感的な既存respectと情報の消去を実現している
