# Service Unit

## Service

```text
[Unit]
# ...

[Service]
Type=forking # | notify

Environment=KEY=VALUE
EnvironmentFile=-/etc/foo

ExecStartPre=/usr/bin/telemetryd pre
ExecStart=/usr/bin/telemetryd start
ExecStop=/usr/bin/telemetryd stop
ExecReload=/usr/bin/telemetryd reload

RuntimeDirectory=telemetryd
RuntimeDirectoryMode=0755

KillMode=process
Restart=on-abort # | on-failure
RestartPreventExitStatus=255

```

* `Type`: 何をもって起動が完了したのかの判定
  * `simple`: 指定のcommandの`fork()`完了したら完了
  * `exec`: `execve()`完了したら完了
  * `forking`: parent processがchildをforkして初期化処理完了後にexitする。parent processのexitをもってsystemdは起動完了と判断する
  * `notify`: 起動処理完了後にsocketにmessageをsendしてsystemdに完了をつたえる　
  * `oneshot`: commandの実行が完了したら、起動成功でserviceを終了
* `Environment`: 環境変数
* `EnvironmentFile`: fileからの環境変数の設定
  * `=-/etc/foo`はなかったら無視する指定になる
* `Restart`: systemdのrestartの制御
* `ExecStartPre`: 実行前の確認処理
* `ExecStart`: 実行command

* `RuntimeDirectory`: `/run`配下に作成するdirecotry

* `KillMode`: processの終了方法 (`man systemd.kill`)

* `Restart`: いまいちわかってない
* `RestartPreventEixtStatus`: restartさせない終了code

### 環境変数

* `MAINPID`: systemdが用意してくれるprocessのPID
