# yaml

## Multiline

### 複数行で書いて1行として解釈する

```yaml
run: >
  cargo clippy
  -D warning
  -A clippy_xxx
```
これは`cargo clippy -D warning -A clippy_xxx`として解釈される

* `>`を使う
  * `\n`がspaceに変換される
  * 末尾には`\n`がつく


### 複数行で書いて複数行として解釈する

```yaml
run_1: |
  command arg arg
  command arg arg

run_2: |-
 aaa
 bbb
```

* 要はliteralで`\n`はそのまま保持される
* `|-`とすると最後の`\n`がカットされる
* `|+`とすると最後に複数の`\n`があっても保持される
