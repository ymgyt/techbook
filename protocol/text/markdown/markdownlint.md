# Markdown Lint

* [`markdownlint`](https://github.com/DavidAnson/markdownlint) というlibがある
  * これをgithub actionsやcliから使う
* CLI
  * [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
    * 2を作りたかった理由があったらしい

## Rule

* `.markdownlint.jsonc` に書く


```jsonc
{
  "default": true,
  "MD022": {
    // Heading の直後に改行を要求しない
    "lines_below": 0,
    "lines_above": 1
  },
  // list の前後に改行を要求しない
  "MD032": false
}
```

* json の keyにruleを書く
  * aliasも設定できるらしい?
