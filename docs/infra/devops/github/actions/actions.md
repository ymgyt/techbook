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

* `name` optional, Actionsのtabで表示される
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

変更したファイルがすべて、`paths-ignore`で指定したファイルにmatchしたらそのworkflowは実行されない。


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
