# Reference

## Shared Reference

`&T` pointer + いくつかの保証がcompilerによってなされた型。

* `Copy`
* shared referenceがpointsしている値は、shared referenceがliveしている間は変化しない


## Mutable Reference

`&mut T`

* compilerは他のthreadがアクセスしていないことを仮定(保証)する
* ownedとの違いはdropする責務があるかどうか
* moveしたい場合は、変わりの値と差し替えることで実現する
