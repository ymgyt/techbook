# cargo-release

* workspaceのcrateのreleaseをおこなってくれる
  * cargo publish
  * Cargo.tomlのversionのbump
    * crate-a -> crate-bとなっている際にcrate-bをbumpすると、crate-aの依存もbumpしてくれる
  * 関連file(CHANGELOG)のfind and replace
    * CHANGELOGのunreleasedをversionにしたり
  * bumpに対応したgit tagの生成とpush
  * bumpして変更されたcodeをgit push

* defaultがdry-run modeなので副作用はおきない
  * `--execute`をつけると実際に副作用がおきる

* github releaseは作ってくれない
  * tag pushをtriggerにしてCDにするのがよさそう

## Usage

* crate-aが`v0.1.1`のときに`v0.1.2`をreleaseしたい場合
  * `cargo release patch --package crate-a`

```sh
# tag(version) を指定
cargo release 0.1.0 -v
```

## Config

以下に定義できる

* release.toml
* Cargo.tomlの`metadata.release`

```toml
[workspace.metadata.release]
# 間違って、feature branchからreleaseしないようにできる
allow-branch               = ["main"]

# 暗黙的にgit add, git commit, git pushする
# ここで指定したcommit messageのcommitが作られる
pre-release-commit-message = "chore: release"

# release実行前の置換処理
pre-release-replacements   = [{ file = "CHANGELOG.md", search = "unreleased", replace = "{{crate_name}}-v{{version}}" }]

tag-message                = "chore: release {{crate_name}} version {{version}}"
```

### workspace 全体で一つのtagを使う

* defaultでは、member crateごとにtagが付与される
* 方針としては、共通設定で、tagを無効化して、ひとつのmemberだけで有効にする

```toml
[workspace.metadata.release]
shared-version             = true
# これで、まずtagを無効化する
tag                        = false
```

いずれかのmember crateで

```toml
[workspace.metadata.release]
# これで、まずtagを無効化する
tag                        = true
```

