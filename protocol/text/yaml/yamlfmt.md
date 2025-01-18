# yamlfmt

yaml の formatter

## config file

以下をconfig fileとして認識する

- `.yamlfmt`
- `.yamlfmt`
- `yamlfmt.yml`
- `yamlfmt.yaml`
- `.yamlfmt.yaml`
- `.yamlfmt.yml`

directory は以下を探す

- current
- `$HOME/.config/yamlfmt`

```yaml

# https://github.com/google/yamlfmt/blob/main/docs/config-file.md
formatter:
  # 現状は basic 固定
  type: basic
  indent: 2
  # 複数行の改行をrespectする
  retain_line_breaks: false
  # 複数行は1行にするが、1行の改行はrespect
  retain_line_breaks_single: true
  disallow_anchors: false
  max_line_length: 0
  # array をindentするか
  indentless_arrays: false
  # content # このコメントのpadding
  pad_line_comments: 1
  trim_trailing_whitespace: false
```
