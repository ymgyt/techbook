# Taint

* Nodeにkey:value:effectの形で指定する
  * effectもtolelationの一致の判定対象となる
  * key1:value1:NoScheduleとkey1:value1:NoExecuteは異なるtaint
* Pod側で、taintに対応するtolerationsを書かないとtaintが付与されたnodeにshedulingされない
* usecase
  * production taintを付与して、production用workloadしたshcedulingされないようにする

