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


### 複数行で書いて複数行として解釈する

```yaml
run: |
  commadn arg arg
  commadn arg arg
```

* 要はliteralで`\n`はそのまま保持される
