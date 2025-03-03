# Alert 

* Grafanaは定期的にalert ruleに基づいてdatasourceにqueryを実行する
  * condition を満たすとalert instanceがfireされる
  * firingとresolvedなalert instance はnotification policyで評価されて、通知される
  * notification policyにはcontact point(通知先)が紐づいている

Alert -> Notification Policy -> Contact pointという関係

* 内部的にalertはalert generatorとalert receiverから構成されている。  
* grafanaはalertmanagerをalaert receiverとして内部的に利用している。
  * grafana内臓のalert managerではなく外部のalertmanagerを指定することもできる

## Alert rule

Alertが発火するruleを定義する。  

* 1つ以上のqueryとexpressionからなる
* conditionがある
* notification policy, contact pointをもつ
* 評価のintervalとconditionが継続する期間を指定する
  * 10秒間隔で評価して、30秒継続したら発火

1. Data sourceを指定する
2. 関数を適用して値にする
  * Lastで最新の値を参照できる
3. Thresholdで比較する

* Alertのstate
  * Normal, Pending, Alerting, No Data, Error


### Label

* Alert同士を区別するためのkey value
* slilenceやnotification policyとの紐付けで使う
* Annotationはadditional metadataを紐づける目的
* matchに使えるoperatorは `=`, `!=`, `=~`, `!~` 

### Alert rule type

* grafanaではなく、lokiやmimirが管理するalertもある
* loki/mimir側にalert管理を任せることで、scaleやsingle point of failureを避けられる
* grafana managedとは機能差がある

### Alert instance

以下のalert rule expressionは複数のtime seriesを作る

```promql
sum by(cpu) (
  rate(node_cpu_seconds_total{mode!="idle"}[1m])
)
```

それぞれのtime seriesに対応してalert instanceが作成される
cpu=0 alert, cpu=1 alert,  ...

### Alert rule evaluation

* alert ruleはevaluation groupに属する
  * evaluation groupにintervalが設定される
* notification policyのalert groupとは違う概念

誤発火を防ぐために、conditionを満たしてから発火までのpending periodを設定できる  
evaluation interval: 30sec, pending period: 90secの場合

[00:30] First evaluation - condition not met.
[01:00] Second evaluation - condition breached. Pending counter starts. Alert starts pending.
[01:30] Third evaluation - condition breached. Pending counter = 30s. Pending state.
[02:00] Fourth evaluation - condition breached. Pending counter = 60s Pending state.
[02:30] Fifth evaluation - condition breached. Pending counter = 90s. Alert starts firing

* 最初にconditionを満たすと、pending stateになる
* 最初にpendingになってからpending period経過すると発火する
  * pending period経過前にconditionが満たされないとnormal stateになる
* pending periodを0に設定すると最初のconditionが満たされた時点で発火する

### Alert rule state

alert ruleは以下のいずれかの状態をとる

* Normal: evaluation engineから返される全てのtime seriesがPendingでも、Firingでもない
* Pending: time seriesに一つ以上のPendingがある
* Firing: time seriesに一つ以上のFiringがある

#### Alert rule health

ruleのstateとは別にhealthの状態もある

* Ok: ruleの評価でerrorが起きていない
* Error: 評価時にerrorが起きている
* NoData: 一つ以上のtime seriesでdataがない
* {status},KeepLast: 設定で、変更された場合これが表示(よくわかってない)

### Alert instance state

alert instance(ruleのlabelにmatchするtime seriesと思っている)

* Normal: working correctly
* Pending: alertのconditionを満たしているが、pending periodを経過していない
* Alerting: 発火中
* NoData: 設定されたtime windowでdataをreceiveしていない
* Error: alert runeの評価に失敗している


## Notification policy

* alertのcontact pointへのroutingを担う
* Root notification policy(default policy)があり、指定されていない場合はこれが適用される
  * 全てのpolicyはdefaultから木構造で作っていく
    * 大まかにlabelで通知先を分けつつ、criticalの場合は別の通知先といった制御を表現できる
    * Contact point,timing,mute timingは親から継承される
      * 子側で上書きできる
* Alertとの関連をlabelで定義できる
  * team="ops"を設定しておくと、そのlabelをもつalertを当該、notification policyのcontact pointに流せる
  * `foo=~[a-zA-Z]+`ような正規表現も書ける

### Grouping

* 複数のalertをgroupingして一つのnotificationにできる
  * systemがdownした際に大量のalertが飛ぶと逆に対応に逆効果になる
* defaultでは、`alertname`と`grafana_foler` labelでgroupingされる

### Timing options

notificationが送られる頻度の制御。

* Group wait: notificationを送るまでに待機する秒数
  * 長いとalertの通知まで送れる
  * 短すぎると通知が不完全になりえる
  * defaultは30sec

* Group interval: alert発火後は、このintervalで通知される
  * defaultは5分

* Repeat interval: groupの状態に変化がない場合に再度通知するまでの時間
  * Group intervalの倍数である必要がある
  * default 4時間

### Mute timing

* 日曜は通知しないというような設定ができる
  * Silenceと違い、定期的な設定ができそう


## Contact point

* 通知先の抽象化。emailだったり、slackだったりいろいろある。　　
* notification templateが紐づく。
  * emailとslackでformatを変えられるので、templateはこの粒度


## Silence

* Notification policy同様、labelを定義できる。labelにマッチしたalertの通知を止められる
  * 何時から何時まで、type=cpuのalertを止めるというようなことができる
  * maintenanceのような一時的な通知の停止を表現

## Alertの止め方

* Silence
  * maintenance等、一時的な場合がusecase
* Mute timings
  * weekend等、定期的に止める場合がusecase
* Pause alert rule evaluation
