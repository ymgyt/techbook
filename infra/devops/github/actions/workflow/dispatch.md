# workflow_dispatchで手動で実行

```yaml
on:
  workflow_dispatch:
    inputs:
      logLevel:
        description: 'Log level'
        required: true
        default: 'warning'
        type: choice
        options:
        - info
        - warning
        - debug
      tags:
        description: 'Test scenario tags'
        required: false
        type: boolean
      environment:
        description: 'Environment to run tests against'
        type: environment
        required: true
```

* API,Browser等からworkflow_dispatch eventを生成することができこれでtriggerできる
* inputも指定できる
* 設定するとUIにRun workflow buttonが現れる

