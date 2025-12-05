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
