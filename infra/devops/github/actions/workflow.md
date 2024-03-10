# Workflow

`.github/workflows` directory以下に作成するyamlがひとつのworkflowを表す。

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
    paths-ignore:
      - 'docs/**'
```

* 変更したファイルがすべて、`paths-ignore`で指定したファイルにmatchしたらそのworkflowは実行されない。
* PRのmergeはpushと判定される

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
```

* API,Browser等からworkflow_dispatch eventを生成することができこれでtriggerできる
* inputも指定できる
* 設定するとUIにRun workflow buttonが現れる


## `permissions`

* Jobごとに`GITHUB_TOKEN`が生成されている。  
* Jobの中でGithub APIを呼ぶ場合は対応する権限の付与が必要になる
  * `contents: write`: Releaseの作成に必要だった

```yaml
permissions:
  # Releaseの作成に必要
  contents: write

```

## `jobs.<job_id>.runs-on`

https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idruns-on

* linux
    * `ubuntu-latest` or `ubuntu-20.04`
    * `ubuntu-18.04`

## `jobs.<job_id>.needs`

* job間の依存関係を定義できる。

```yaml
jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - run: ./setup_server.sh
  build:
    needs: setup
    runs-on: ubuntu-latest
    steps:
      - run: ./build_server.sh
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: ./test_server.sh
```

## `jobs.<job_id>.timeout-minutes`

jobの最大実行時間。

```yaml
jobs:
  xxx:
    timeout-minutes: 60
```

## `jobs.<job_id>.strategy.matric`

環境やversionだけ変えてjobを実行させる

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [6, 8, 10]
    steps:
      - uses: actions/setup-node@v2
        with:
          node-version: ${{ matrix.node }}
```

## `jobs.<job_id>.if`

* jobの実行に条件を付与できる

```yaml
jobs:
  create-api-release:
    runs-on: ubuntu-latest
    if: ${{ startsWith(github.ref, 'refs/tags/synd-api') }}
```

* `{{ }}`はつけておけばよさそう
* `if: ${{ startsWith(github.ref, 'refs/tags/synd-api')}}`
  * tagの先頭にmatchした場合だけjobを実行


## Workflow command

* Github actionの慣習的なもの

### `PATH`の設定

* 対象dirを後続のaction(step)から見えるようにする

```shell
echo "$HOME/.local/bin" >> $GITHUB_PATH
```
