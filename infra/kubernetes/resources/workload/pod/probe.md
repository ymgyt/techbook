# Pod Probe

| Probe       | 判定内容                   | 失敗時 |
| ---         | ---                        | ---    |
| `Readiness` | Podがrequestを処理できるか | Serviceのrouting対象からはずされる |
| `Liveness`  | Podが生きているか          | kubeletにより停止される |
| `Startup`   | 初回起動が成功したか       | kubeletにより停止される |

## Readiness Probe

Podがrequestを受け付けられるかの判定。  
Probeが失敗すると、podがServiceからはずされる。  
その後に成功すると、再びService配下に戻る。


## Liveness Probe

Podが実行中か判定。  
Probeに失敗すると、kubeletにより停止。  
`restartPolicy`に応じて、再作成される。

## Startup Probe

Podの初回起動に成功したかの判定。  
ReadinessやLivenessの前に動く。  
失敗するとkubeletに停止される。  
`restartPolicy`に応じて再作成される。


## Probeの実装方法

* command
* http request
* tcp
* gRPC request