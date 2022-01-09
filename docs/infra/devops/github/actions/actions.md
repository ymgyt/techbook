# Github Actions

## Workflow

`.github/workflows` directory以下に作成するyamlがひとつのworkflowを表す。

```yaml
name: learn-github-actions
on: [push]
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
* `runs-on` 
  * jobをどのosで実行するか決める。virtual machineの指定。
* `uses`
  * actionの実行keyword

### `on`

```yaml
on:
  push:
    paths-ignore:
      - 'docs/**'
```

* 変更したファイルがすべて、`paths-ignore`で指定したファイルにmatchしたらそのworkflowは実行されない。
* PRのmergeはpushと判定される

#### `workflow_run`

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


### `jobs.<job_id>.runs-on`

https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idruns-on

* linux
  * `ubuntu-latest` or `ubuntu-20.04`
  * `ubuntu-18.04`

### `jobs.<job_id>.needs`

job間の依存関係を定義できる。

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

### `jobs.<job_id>.timeout-minutes`

jobの最大実行時間。

```yaml
jobs:
  xxx:
    timeout-minutes: 60
```

### `jobs.<job_id>.strategy.matric`

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


## Actions

```yaml
steps:
  - uses: actions/javascript-action@v1.0.1
```

定義されているのは
* public repository
* same repository
* Docker Hubのdocker container
