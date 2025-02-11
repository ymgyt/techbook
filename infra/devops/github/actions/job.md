# Workflow Job

## `jobs.<job_id>.runs-on`

* linux
    * `ubuntu-latest` or `ubuntu-20.04`
    * `ubuntu-18.04`

## `jobs.<job_id>.needs`

* job間の依存関係を定義できる。
  * string, `[string]` 両対応

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

* defaultは360分らしいので基本的につねに設定する

## `jobs.<job_id>.strategy.matrix`

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

```yaml
jobs:
  create-api-release:
    runs-on: ubuntu-latest
    if: ${{ startsWith(github.ref, 'refs/tags/synd-api') }}

  job2:
    if: ${{ ! contains(github.event.pull_request.user.login, '[bot]') && ! contains(github.event.pull_request.user.login, 'internal-tools') && toJSON(github.event.pull_request.assignees) == '[]'}}
```

* jobの実行に条件を付与できる
* 暗黙的に `${{ }}` 中で評価される仕様があるが、`!` はyamlに書けないので、明示的に`${{ }}`を書くのがよい
  * `if: ${{ input.foo}} == 'true'` のように expression からでないように注意
  * `if: ${{ input.foo == 'foo' }}` こう書く

* `if: ${{ startsWith(github.ref, 'refs/tags/synd-api')}}`
  * tagの先頭にmatchした場合だけjobを実行

* `${{ COND && COND }}` で and を表現
* builtins
  * `contains(stack, needle)` : needleがstackのsubstringならtrue
  * `contains(["aa,bb"], "aa")`: 第一引数がarrayのもサポート。その場合はelement単位の完全一致
