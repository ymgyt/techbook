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

### Install

serviceをenable/disableした際の挙動の設定。  
systemdではなく、systemctlが解釈するらしい。(man systemd.unitによると)

```text
[Unit]
# ...

[Service]
# ...

[Install]
Wants=a.target b.target
WantedBy=multi-user.target
Alias=sshd.service
```

* `Requires`: 依存するservice。依存先が起動に失敗した場合はunitを起動しない。
* `Wants`: このserviceが依存するservice。起動していなければsystemdが起動する。起動に失敗したら無視する
  * 起動の順番はAfter,Beforeで指定する。指定がないとWantsと同時に起動される
* `After`: このunitよりも先に起動するunit
* `Before`: このunitよりも後に起動するunit

* `WantedBy`: なにかを実際にinstallするわけではなく、unitの有効無効の制御
  *  `systemctl enable`した際に`/etc/systemd/system/multi-user.target.wants/`にsymlinkが作成されることに対応する
* `Also`: enableした際に同時に操作?するunit
* `Alias`: serviceのalias. sshとsshdがdistroで揺らぐ場合があったりするらしいのでこれで吸収できる

### 環境変数

* `MAINPID`: systemdが用意してくれるprocessのPID

