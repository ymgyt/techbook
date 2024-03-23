# helmCharts

* kustomizeからhelm chartを利用する
* kustomize build時に`--enable-helm` flagが必要
  * `helm` commandを実行するため許可が必要
  * `helm` がPATHにいる必要がある
* helmの全ての機能がサポートされているわけではない
  * https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/helmcharts/#long-term-support

`kustomization.yaml`

```yaml
helmCharts:
- name: minecraft
  includeCRDs: false
  valuesInline:
    minecraftServer:
      eula: true
      difficulty: hard
      rcon:
        enabled: true
  valuesFile: values.yaml
  additionalValuesFiles: []
  releaseName: foo
  version: 3.1.3
  namespace: "foo"
  repo: https://itzg.github.io/minecraft-server-charts
  valuesMerge: "override"
  # kustomize v5.3.0以降で利用可能
  kubeVersion: 1.29.0
  apiVersions:
    - "policy/v1"

helmGlobals:
  chartHome: my-charts-dir
```

* `version` 省略した場合はlatestを利用
* `namespace` `helm template --namespace`に対応
* `valuesFile`でhelmのvaules.yamlを参照できる
* `valuesMerge`: merge | override | replace
* `additionalValuesFiles`: 追加のvalues
* `skipHooks`: helm installと差分でる場合に検討? IDRU
* `kubeVersion`: helm template側で、apiGroupのversionの分岐で参照されている
* `apiVersions`: kubernetesのapi versionsを指定できるらしい。
  * helmのtemplate側で、`policy/v1/PodDisrutpionBudget`か`policy/v1beta`かを分岐する処理で参照されている

* `helmGlobals`
  * `chartHome` defaultではcurrentに`charts` dirが作成されhelmのchart(template)がすべて展開される(pull,untar)
  * これを別directoryに変更できる
  * `--load-restrictor LoadRestrictionsNone`が必要になる

## 参考

* [HelmChartInflationGenerator](https://kubectl.docs.kubernetes.io/references/kustomize/builtins/#_helmchartinflationgenerator_)
* [公式Example](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/chart.md#best-practice)

