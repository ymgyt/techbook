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
$env.LOG_LEVEL = debug
$env.LOG_CONTEXT = "foo"
$env.LOG_FILE = /tmp/renovate.log
$LOG_FILE_LEVEL = "trace"
$LOG_FORMAT = "pretty"  # or json
$LOG_LEVEL = "debug" # info | debug | trace

pnpm start ymgyt/test-repo [--dry-run = full]
```

* `--dry-run` dry runで起動


## Source Code Memo

* `lib/renovate.ts` がentry point
