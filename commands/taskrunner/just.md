# just

* 設定fileは`justfile`

```sh
# List recipes
just --list

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

# Command evaluation
dst := `terraform output foo`

alias f := foo


default:
  just --list

foo:
  echo {{name}}

silent:
  @echo {{name}}
```

* `@`を先頭につけるとcommand自体の出力を抑えられる
