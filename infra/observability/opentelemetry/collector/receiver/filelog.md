# filelog

Kubernetesで動かす場合、kubelet(container runtime)が出力するPodのlogを収集する。

## Config

```yaml
receivers:
  filelog:
    include:
    - /var/log/pods/*/*/*.log
    exclude: []
    start_at: end
    force_flush_period: 30s
    encoding: utf-8
    include_file_name: false
    include_file_path: true
    include_file_name_resolved: false
    include_file_path_resolved: true
    poll_interval: 10s
    fingerprint_size: 1kb
    max_log_size: 1MiB
    max_concurrent_files: 1024
    attributes:
      attr_test: attr_test_v1
    resource:
      resource_test: resource_test_v1
    operators: {}
```

* `include`: 監視対象のfile
  * directory構成はkubelet次第
  * `/var/log/pods/<namespace>_<pod-name>_<pod-uuid>/<container>/<restart_count>.log`というruleになっている

* `exclude`: 除外対象のfile
* `start_at`: collector起動時にfileをどこから読むか
  * `beginning `or `end`
  * 複数回再起動した場合、beginningにすると同じlogが複数回送られる?

* `force_flush_period`: bufをflushする期間。
  * 長くするほどリアルタイム性が失われる?

* `include_file_{name,path}`: log telemetryへfile path情報を付与するか
* `include_file_{name,path}_resolved`: symlink解決後のpathをtelemetry に付与するか
  * /var/log/pods/ 配下は実際にはcontainer runtime配下のdirへのsymlinkになっている
* `poll_interval`: filesystem pollのinterval

* `fingerprint_size`: fileの同一性を判定するためのfingerpintの設定値 
  * どう利用されるのかわかっていない

* `max_log_size`: logとして読み込む1行の最大値と思われる

* `max_concurrent_files`: 同時に読みに行くfileの数
  * 実装的にgoroutineの数?

* `attributes`: log telemetryのattributes?
* `resource`: log telemetryのresource


### operators

log fileが読み込まれた1行はentryを言われる。  
operatorはentryを加工する責務をもつ。  
operatorのchainを設定して、log pipelineを作るのがfilelogの思想。 

* `type`をもつ
* `id`を付与できる。付与されない場合は`type`が使われる
* operatorのoutputは次のoperatorに渡される。最後のoperatorの出力がreceiverからの出力になる
  `output`を指定できる場合は次のoperatorを指定できる

実装としてはstanzaが使われており[doc](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/pkg/stanza/docs)がある。

* [kubernetesのexample](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/v0.69.0/examples/kubernetes/otel-collector-config.yml)
