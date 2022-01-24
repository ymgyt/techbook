# Conventional Commits

commit messageを以下のformatにする

```text
<type>[optional scope]: <description>

[optional body]

[optional footer]
```

## type

* `fix`
  * bugのfix
  * semverではpatch
* `feat`
  * 機能追加
  * semverではminor
* `build`
* `ci`
* `docs`
  * documentation onlyの変更
* `perf`
  * performance
* `refactor`
* `style` 
  * white-space, formatting
  * codeの意味に影響を与えない
* `test`

### Initial commit

```
$ git init # creates repository
$ git commit --allow-empty -m'Initial empty commit' # creates empty commit`
```

* `--allow-empty` を指定すると空のcommitが作れる
