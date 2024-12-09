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

## Alarm

* Period: metricsを評価してdata point を算出する期間(秒)
* Evaluation Periods: alarmの状態を変化させるにあたり幾つのdata pointを参照するか
  * data point と period は同じ意味(1 period期間に1 data pointが生成される)
* Datapoints to alarm: evalution periods中いくつのdata pointが閾値を超えたら stateをALARMに変化させるか


* **periodが1分以上のAlarmの評価は1分毎に実行される**
  * periodが10秒,30秒の場合は10秒間隔。
