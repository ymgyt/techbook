# Markdown Lint

* [`markdownlint`](https://github.com/DavidAnson/markdownlint) というlibがある
  * これをgithub actionsやcliから使う
* CLI
  * [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2)
    * 2を作りたかった理由があったらしい

* install
  * `pnpm install --save-dev markdownlint-cli2`

## Usage

```sh
# node_modules以外の全markdownを対象にする
# globを複数書ける
markdownlint-cli2 **/.*md !node_modules
```

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
