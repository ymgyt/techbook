# config

起動時に以下のfileが読み込まれる。

```sh
source path/to/env.nu
source path/to/config.nu
```

pathは以下で確認できる

* `$nu.env-path`
* `$nu.config-path`


## Alias

```nu
alias g = git
alias c = cargo
```

設定は`config.nu`に書いておく

## Completion

補完の設定について

### External completer

別processに補完をまかせる

```nu
# 補完用のclosureの型は決まっている
let alias_completer = {|spans: list<string>|

  # alias展開のbugのworkaround
  let expanded_alias = scope aliases
      | where name == $spans.0
      | get -i 0.expansion

  let spans = if $expanded_alias != null {
    $spans
      | skip 1
      | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  completions: {
    external: {
      enable: true
      completer: $alias_completer
    }
  }
}```

* closureの戻り値はvalueを含むtableらしい
  * docを発見できず。実装みるしかなさそう
