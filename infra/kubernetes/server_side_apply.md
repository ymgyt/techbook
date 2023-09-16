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

* `matadata.managedFields`にどのfieldが誰によって制御されているかの情報を保持している


## 参考

* [公式Blog](https://kubernetes.io/blog/2022/10/20/advanced-server-side-apply/)