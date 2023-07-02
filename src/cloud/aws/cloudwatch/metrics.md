# Metrics

## Metricsとは

* 時系列データの集合
* namespace + name + dimensionsで一意に特定できる
  * namespace: `SRE/OPSBOT` ,name: `cloudbilling`, dimensions `service=xxx, region=yyy`


### Metrics関連のconsept

* namespace
  * metrics nameの名前空間
  * `AWS`はawsのreserved

* dimensions
  * metricsに付与できるkey value
  * metricsが表すリソースの識別子なんかを付与する

