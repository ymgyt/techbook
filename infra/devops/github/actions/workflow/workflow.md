# Workflow


* `.github/workflows` directory以下に作成するyamlがひとつのworkflowを表す。
* workflow の skip
  * `[skip ci]`, `[ci skip]`, `[skip actions]`, `[actions skip]`
  * `push`, `pull_request` の event trigger

```yaml
name: learn-github-actions
run-name: expression ${{ github.foo }}
on: [push]

# 全てのjobから参照できる
env:
  ENV_KEY: ENV_VALUE

permissions:
  contents: write

# 全 jobのdefaultになる(job levelでも指定可)
defaults:
  run:
    # bashを指定すると内部的には
    # bash --noprofile --norc -eo pipefail {0} が実行される
    shell: bash
    working-directory: ./scripts

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
  
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

```yaml
on:
  push:
    # (main branch AND match paths) OR (tags v*)
    branches: [main]
    paths:
      - 'Cargo.*'
      - rust-toolchain.toml
      - 'src/**'
    tags: ["v*"]
```

* `branches` と `paths` は AND
* `tags` は OR
* `branches`, `paths`, `tags` を指定すると
  * `(branches AND paths) OR tags` になる...!


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

## `permissions`

* Jobごとに`GITHUB_TOKEN`が生成されている。  
  * `write`は`read`も含む
  * 指定しないものには`none`がsetされる
* toplevelに定義するとworkflow全体に及ぶ
  * jobごとに定義もできる
  * stepごとにはできない
* Jobの中でGithub APIを呼ぶ場合は対応する権限の付与が必要になる
  * `contents: write`: Releaseの作成に必要だった
* [一覧](https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions#permissions)

```yaml
permissions:
  # Releaseの作成に必要
  # readはdefaultで付与されている
  contents: write

  # JobからPRにコメントを投稿する際に必要
  pull-requests: write

  # OpenID Connect(OIDC) tokenのfetchにwriteが必要
  id-token: write

  # workflow-run関連?
  actions: write
```


## Workflow command

* Github actionの慣習的なもの

### `PATH`の設定

* 対象dirを後続のaction(step)から見えるようにする

```shell
echo "$HOME/.local/bin" >> $GITHUB_PATH
```
