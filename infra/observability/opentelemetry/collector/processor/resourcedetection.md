# resource detection

実行環境の情報を取得してResourceに付与してくれる。


## Usage

`v0.77`

```yaml
processors:
  resourcedetection/system:
    detectors: ["system"]
    override: false
    attributes: ["host.name"]
    system:
      hostname_sources: ["os"]
```

* `detectors`で有効にするcomponentを指定する
* `attributes`: 取得するattributeを指定できる
   * 最新ではdetectorごとに指定するようなapiになっていたので注意
* `system`
  * `hostname_sources`: hostnameをどのように取得するかを指定できる