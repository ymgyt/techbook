# reviewdog

* linterの出力をparseして、PR等に反映する
* linterの結果をgit diffでfilterし、PRで変更された箇所だけ報告する

```sh
# 対応するlinterのリスト一覧
reviewdog -list
```

* 終了コードの制御
  * `-fail-on-error` defaultだと違反があっても0で終わる
  * `fail-level` どのレベルの違反をfailと判定するか
  *`-fail-on-error=true -fail-level=error` で errorがあった場合1で終わる

* reporter
  * `-reporter=github-pr-review`: PR Review
    * GITHUB_TOKENに `pull-requests: write` が必要
    * PRに差分がないと指摘できないので、filter-modeとの関係に注意がいりそう?

  * `-reporter=github-pr-check`
    * GitHub checksがわかっていない
  * `-reporter=github-check`
    * pushのようなPRでない場合でも動く?

  * `-reporter=github-pr-annotations`
    * `::warning file=foo,line=n ::<message>`のようなworkflow commandを利用したannotation
    * `-tee`をつけるとログにも残る?

  * `-reporter=local`: default

* `-name`: linterとして表示される名前

* `-filter-mode`
  * `added`: 追加された行だけ
  * `diff_context`: 差分で変更された行の前後の行
  * `file`: 差分があったfile全体
  * `nofilter`: filterせず全て

* `-tee`: repoterへの出力に加えてstdoutにも出す

