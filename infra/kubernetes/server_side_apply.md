# Server Side Apply

SSAについて。
1.22でGA。

## Client Side Apply

* kubectl applyで適用するmanifestはobjectの完全な情報を保持していない
  * Api側が管理しているfieldがある?
* Apply時にはclient(kubectl)側で、respectする既存のfieldと更新したいfieldをmerge(計算)する必要がある
* `metadata.kubectl.kubernetes.io/last-applied-configuration`に前回applyした情報を保持している
  * この情報を使えば、respectするべき既存のfieldがわかる


## SSA

* kubectlではdefaultでは表示されないので、optionをつける必要がある
* `matadata.managedFields`にどのfieldが誰によって制御されているかの情報を保持している
* 同じ値でapplyすると共同所有者になる
  * その後、fieldを削除してapplyすると、所有権の放棄になるだけで実際にはfieldが削除されるわけではない
  * 自分が所有者でないfieldを更新しようとするとconflict(失敗)する



## 参考

* [わかる metadata.managedFields](https://www.slideshare.net/slideshow/metadatamanagedfields-kubernetes-meetup-tokyo-48-251269647/251269647#2)
* [Server Side Apply Is Great And You Should Be Using It](https://kubernetes.io/blog/2022/10/20/advanced-server-side-apply/)
