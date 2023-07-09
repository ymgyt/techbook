# CHANGELOG

* 提案されている決まり事
  * https://keepachangelog.com/en/1.0.0/

```markdown
# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.1] - 2021-03-27
### Changed
- rename `calculator` package to `clc-core`
- rename `calculator-cli` to `clc`

## [0.1.0] - 2021-03-26
### Added
- `clc` binary published.
```

* releaseされたversion毎に`[1.2.3]`のようなsectionをきる
* `[Unreleased]`を用意して都度更新していくとreleaseの際に移すだけになって便利
* 変更内容の分類
  * Added: 新機能
  * Changed: 既存機能の変更
  * Deprecated: 将来的に削除される機能
  * Removed: 削除された機能
  * Fixed: バグフィックス
  * Security: 脆弱性修正のためユーザーにアップデートを促す場合

## References

* https://blog.yux3.net/entry/2017/05/04/035811
