# Workflow

* `.github/workflows` directory以下に作成するyamlがひとつのworkflowを表す。
* workflow の skip
  * `[skip ci]`, `[ci skip]`, `[skip actions]`, `[actions skip]`
  * `push`, `pull_request` の event trigger


```yaml
name: learn-github-actions
on: [push]

# 全てのjobから参照できる
env:
  ENV_KEY: ENV_VALUE

permissions:
  contents: write
  
jobs:
  check-bats-version:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '14'
      - run: npm install -g bats
      - run: bats -v
```

* `name` optional, Actionsのtabで表示される。他のworkflowを参照するさいの識別子になる。
* `on`
    * workflowのtriggerを決める
* `jobs`
    * defaultでは各jobは並列に実行される
* `permissions`
  * 実行されるjobに権限を付与する


## `on`

```yaml
on:
  push:
    branches: [main]
    paths-ignore:
      - 'docs/**'
```

* 変更したファイルがすべて、`paths-ignore`で指定したファイルにmatchしたらそのworkflowは実行されない。
* PRのmergeはpushと判定される

### pull requestをtriggerにする

```yaml
on:
  pull_request:
    # typesを指定しない場合にはこのtypeが指定されたことになる
    types: [opened, synchronize, reopened]
```

* eventには`types`で指定できるactivitiy typeが存在する
* 省略時はすべてのtypeが指定されてことになる
  * ただし、pull_requestだけは省略時のdefault typesが存在する
* OSSのようにforkしたrepoからPRを作成する場合にはpush eventは発火しないのでpull_request triggerが必要になる
* PRの中でworkflowを変更した場合、PRの変更されたworkflowが実行される
  * この挙動を避けたい場合は`pull_request_target` をtriggerにする
  * `pull_request_target` であれば、PRで実行されるworkflowはbase


### tagのpushをtriggerにする

```yaml
on:
  push:
    tags:
    - 'v*.*.*'
```

### `workflow_run`

```yaml
name: deploy
on:
  workflow_run:
    workflows:
    - "lint"
    - "test"
    branches:
    - main
    types:
    - completed

jobs:
  deploy:
    runs-on: ubuntu-18.04
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    steps:
    - uses: actions/checkout@v2
```

* 他のworkflowのあとにworkflowを実行したいことを表現できる
* branchesの条件はよくわかっていない
* 依存するworkflowの成功を前提にしたい場合はifを書く
* workflow file自体がdefault branch(main)にある必要があるので、feature branchだとうまく動作確認できないかも(理解が曖昧)

### schedule実行する

```yaml
name: Scheduled Workflow
on:
  schedule:
    - 5 16 * * *
```

* cron tab方式で指定する

### workflow_dispatchで手動で実行

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


## `permissions`

* Jobごとに`GITHUB_TOKEN`が生成されている。  
* toplevelに定義するとworkflow全体に及ぶ
  * jobごとに定義もできる
  * stepごとにはできない
* Jobの中でGithub APIを呼ぶ場合は対応する権限の付与が必要になる
  * `contents: write`: Releaseの作成に必要だった

```yaml
permissions:
  # Releaseの作成に必要
  # readはdefaultで付与されている
  contents: write
  # JobからPRにコメントを投稿する際に必要
  pull-requests: write

```


## Workflow command

* Github actionの慣習的なもの

### `PATH`の設定

* 対象dirを後続のaction(step)から見えるようにする

```shell
echo "$HOME/.local/bin" >> $GITHUB_PATH
```
