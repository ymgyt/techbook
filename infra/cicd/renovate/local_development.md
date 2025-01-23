# Local Development

## Setup

```sh
# .nvmrc にnode versionが指定してあるのでrespectする
fnm use
corepack enable

pnpm install
pnpm test
```

## Run

```sh
$env.RENOVATE_TOKEN = (cat gh_pat_with_repo_scope)

$env.LOG_CONTEXT = "foo"
$env.LOG_FILE = /tmp/renovate.log
$env.LOG_FILE_LEVEL = "trace"

$env.LOG_FORMAT = "pretty"  # or json
$env.LOG_LEVEL = "debug" # info | debug | trace

$env.RENOVATE_CONFIG_FILE = config.js

# renovateが更新対象にするbranch 検証でしたい場合に利用できる
$env.RENOVATE_BASE_BRANCHES=feature/foo

pnpm start ymgyt/test-repo [--dry-run = full] [--schedule=] [--use-base-bracnh-config merge]
```

* `--dry-run` dry runで起動
  * `null`: 通常の起動
  * `"extract"`: managerがparseするpackage fileの抽出のみ
  * `"lookup"`: 新versionの検索まで
  * `"full"`: branchとPRの変更以外を実施

* `--schedule=` を指定することで、適用されるconfigのscheduleを無視して検証できる
* `--use-base-branch-config merge` `RENOVATE_BASE_BRANCHES`を指定した場合にそのbranch のconfigをdefault branchとmergeする


## Otel

* [example](https://github.com/renovatebot/renovate/blob/main/docs/usage/examples/opentelemetry.md)


## Source Code Memo

* `lib/renovate.ts` がentry point

* Configの解決
* PR の作成
* PR の merge

### Split

* renovateの実装上の処理の単位

1. init
2. extract
  * manager(cargo)がpackage file(Cargo.toml)からdep(anyhow)をextractする
3. lookup
  * extractしたdepのdatasourceから新しいversionがあるかを取得する
4. onboarding
  * Onboarding PRの作成
5. update
  * PRの作成,rebase,merge

### 実行時間

renovate の独自概念として、split としてRepositoryの各処理を分割しており、それぞれの実行時間がわかる

```text
DEBUG: Repository timing splits (milliseconds) (repository=ymgyt/foo)
"splits": {
  "init": 1000, 
  "extract": 2000, 
  "lookup": 3000, 
  "onboarding": 0, 
  "update": 4000
}
```

* `update`は PRを作成したり更新したり
