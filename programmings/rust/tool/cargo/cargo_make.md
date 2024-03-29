# cargo make

* `Makefile.toml`を作成する。
* `[task.xxx]`でtaskを定義する
  * `cargo make xxx`で実行できる
* `cargo make --list-all-steps` 定義されているtaskを出力する
  * `cargo make --list-category-steps "My Category"`でcategoryを指定



## `Makefile.toml`

```toml
[tasks.integration]
command = "cargo"
args = ["test", "--test", "integration_test", "--",  "--nocapture"]

[tasks.init]
dependencies = [
    "cargo_install",
    "add_wasm_target"
]

[tasks.cargo_install]
command = "cargo"
args = ["install", "trunk", "wasm-bindgen-cli"]

[tasks.add_wasm_target]
command = "rustup"
args = ["target","add", "wasm32-unknown-unknown"]
```

## Variables

環境変数で定義する

```toml
[env]
GRAPHQL_ENDPOINT = "http://localhost:8000/graphql"
GRAPHQL_SCHEMA_PATH = "rust/client/schema.json"

[tasks.xxx]
script = '''
echo "${GRAPHQL_ENDPOINT}"
'''
```

実行時に渡す場合は`cargo make --env KEY=VALUE task`

## 他のfileのimport(extend)

```toml
extend = [
    { path = "dev/makefiles/format_makefile.toml" },
    { path = "dev/makefiles/lint_makefile.toml" },
    { path = "dev/makefiles/test_makefile.toml" },
]
```

* `Makefile.toml`を複数fileに分割できる
* importされたMakefileのcurrent dirはrootのfile

## Workspace

* workspace top levelで`cargo make my-task`を実行すると各member dirで`my-task`を実行する動きになる
* memberではなくtop level直下でtaskを実行したい場合は
  * `--no-workspace`を付与する `cargo make --no-workspace mytask`
  * task定義に`workspace = false`を付与する

```yaml
[tasks.lint]
workspace = false
```

## `[config]`
```yaml
[config]
# https://github.com/sagiegurari/cargo-make#disabling-workspace-support
default_to_workspace = false
skip_core_tasks = true
skip_git_env_info = true
skip_rust_env_info = true
skip_crate_env_info = true
```

* `default_to_workspace`: falseを設定しておくと、workspaceにMakefileを置いたときにtop levelで実行してくれる。
* `skip_*`: Rust project以外でもろもろskipできる

## `tasks`

```toml
[tasks.lint]
description = "Apply lint"
toolchain = "nightly"
command = "cargo"
args = ["clippy", "--all-features", "--all-targets", "--", "--deny", "warnings"]
```

* `toolchain`でstable,nightlyを指定できる

### `install_crate`

```toml
[tasks.wasm]
install_crate = { crate_name = "wasm-pack", binary = "wasm-pack", test_arg = "--version", min_version = "0.8.1"}
command = "wasm-pack"
```

* installするcrateを指定できる
* `min_version`も指定できる
* `version`を書くと厳密に指定できる

### `cwd`

```yaml
[task.change_dir]
cwd = "./xxx"
command = "pwd"
```
* current working directoryを指定できる

### `script`

```yaml
[tasks.docs-generate-plantuml]
description = "Generate docs plantuml files"
script = "./docs/puml/generate.sh"
```
* 実行するscriptを指定できる
  * `script = { file = "path/to/xxx.sh }`のようにするとscript側のdirectoryがおかしくなった。

### 依存task

```yaml
[tasks.xxx]
dependencies = ["task_a", "task_b"]
run_task = [
  { name = ["docker_build", "docker_push"] }
]

```

* `dependencies`は実行前に起動される
* `run_task`は実行後の起動される

### init

`init`というtaskは特別扱いされ、すべてのtask実行前に実行される.

```toml
[config]
init_task = "_init"

[tasks._init]
```

とすると名前を変えられる

### subcommand

`cargo make server run`のようにsubcommand likeにしたい場合。

```yaml
[tasks.top]
private = false
extend = "_subcmd_1"
env = { "SUBCMD" = "top"}

[tasks.top_sub]
private = false
extend = "_subcmd_2"
env = { SUBCMD = "top_sub"}

[tasks.top_sub_verb]
command = "echo"
args = [ "hello" ]

[tasks._subcmd_1]
private = true
script = '''
#!@duckscript

cm_run_task ${SUBCMD}_${1}
'''

[tasks._subcmd_2]
private = true
script = '''
#!@duckscript

cm_run_task ${SUBCMD}_${2}
'''
```

* `extend`はextendされる側のpropertyを引き継ぎつつoverrideする
* `cargo make top sub verb`
 * `top` -> `top_sub` -> `top_sub_verb`

