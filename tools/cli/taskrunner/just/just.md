# just

* 設定fileは`justfile`

```sh
# List recipes
just --list --list-submodules

# moduleのrecipeはPATHを指定
just --list foo

# More concise
just --summary

# Show variable
just --evaluate name
```

## justfile

```just
set shell := ["nu", "-c"]

name := "ymgyt"

# Load environment variables
home_dir := env_var('HOME')
profile := env_var_or_default('PROFILE', 'DEFAULT')
# env is alias for env_var and env_var_or_default
region := env('REGION', 'somewhere')

# export environment variables
export FOO := 1

# Command evaluation
dst := `terraform output foo`

alias f := foo


default:
  just --list

foo:
  echo {{name}}

silent:
  @echo {{name}}

# 可変長引数
build *flags:
    nix develop .#ebpf --command cargo task build-ebpf {{ flags }}

# Use parameter
[confirm]
deploy env stack region=region:
  ENV={{env}} command --stack {{stack}} --region {{region}}

# variadic parameters
run *flags:
  cargo run -- {{flags}}
```

* `@`を先頭につけるとcommand自体の出力を抑えられる
* parameterに`*`をつけるとzero or moreの可変長にできる
  * 与えられなければ空のstring


### Attribute

```just
[private]
helper:
  echo "helpler"

[confirm("Do operation?")]
operation:

[linux]
check:
  echo "Linux"

[macos]
check:
  echo "mac"

```

* `[private]`
  * `just --list`に表示されない
  * `_helper`としても同じ

* `[confirm]`
  * task実行時にy/n入力の機械をくれる
  * `--yes`でskipできる

* `[linux]`, `[maxos]`でplatformの切り分けができる
* `[no-cd]`
  * defaultではjustfileが定義してあるdirにcdするがその挙動をやめる

## Modules

```just
export var1 := 'key1'

mod foo 'etc/just/run.just'
```

`etc/just/foo.just`

```just
bar:
  echo "bar"
  echo $var1
```

* `just foo bar` で実行できる
  * `just foo::bar`

* 変数の受け渡し
  * import側がexportすると環境変数として被import側にみえる
* `set shell`は受け継がれなかった


## 引数渡し方

```just
# 位置引数
# just greet world → "hello world"
greet name:
    echo "hello {{name}}"

# デフォルト値付き
# just serve → port="8080" / just serve 9090 → port="9090"
serve port="8080":
    cargo run -- --port {{port}}

# 可変長(0個以上)
# just build → flags="" / just build --release --verbose → flags="--release --verbose"
build *flags:
    cargo build {{flags}}

# 可変長(1個以上、引数なしはエラー)
# just test integration → args="integration"
test +args:
    cargo nextest run {{args}}

# 変数オーバーライド (呼出時はレシピ名の前: just env=prod deploy)
env := "dev"
deploy:
    echo "deploying to {{env}}"

# env変数エクスポート ($付きパラメータが子プロセスの環境変数になる)
# just run-with-env production → $APP_ENV=production
run-with-env $APP_ENV:
    printenv APP_ENV

# [arg] long option (v1.46.0+)
# just create --name foo → name="foo"
[arg("name", long="name")]
create name:
    echo "creating {{name}}"

# [arg] flag (v1.46.0+)
# just serve-app → no_auth="" / just serve-app --no-auth → no_auth="true"
[arg("no_auth", long="no-auth", value="true")]
serve-app no_auth="":
    echo "auth disabled: {{no_auth}}"
```
