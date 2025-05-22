# textlint

```sh
# install
pnpm install --save-dev textlint

# install rule
pnpm install --save-dev textlint-rule-no-todo

# crate .textlintrc file
npx textlint --init

# run linter
npx textlint [--debug] README.md
```

* pluginとしてruleを追加していく


## `.textlintrc.json`

* `npx textlint --init` で作成

```json5

{
	"plugins": {},
	"filters": {},
	"rules": {
    // https://github.com/textlint-ja/textlint-rule-no-synonyms
		"@textlint-ja/no-synonyms": {
			// 許可するワード
			allows: ["ファイル", "メンバー", "リリース", "データ", "サービス", "デフォルト", "リンク"],
			preferWords: [],
			allowAlphabet: false,
			allowNumber: false,
			// セットアップとインストールが怒られたりするのでtrue
			allowLexeme: true,
		}
	}
}
```


## Plugins

### Filter

* https://github.com/textlint/textlint-filter-rule-comments
  * コメントでdisableを制御できるやつ
