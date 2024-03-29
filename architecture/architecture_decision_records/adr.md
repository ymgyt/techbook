# Architecture Decision Records (ADR)

開発メンバー間でどうして今の構成になっているのかを共有するための取り組みです。  
"アーキテクチャに関する意思決定"がなにを含むかについては厳密に決めていません。ドキュメントにしておけば後から入ってくるメンバーの人に役立ちそうくらいを基準にしています。

## 運用方法

ADRを作成したり変更する場合の方法について。

### ADRの作成

誰の許可も必要なく、自由に作成してください。

1. プロダクトのディレクトリ配下に、`<sequence_number>-<title>.md`のフォーマットでファイルを作成します
   1. `<sequence_number>`はディレクトリ内で連番で3桁ゼロ埋め
      1. `002-use-xxx.md`
   2. デリミターは`"-"`を利用
2. `template.md`の項目にそって内容を記載します
   1. template外の項目を追加するのは自由
3. PRを作成して、`main`にセルフマージ
   1. 現状、reviewerの指定は不要
4. Slack等で作成した旨を共有

### ADRの更新

既存のADRを更新する場合について。

1. 内容を更新してPRを作成
   1. Original Authorをreviewerに追加
      1. Original Authorがチームを離れている場合は不要
2. Approveされたのち、`main`にセルフマージ

### ADRの破棄

既存のADRを破棄して、新しいADRを作成する場合について。

1. ADRの作成に基づいて新規のADRを作成する
   1. Statusに破棄されたADRへのリンクを記載
2. 破棄されたADRのStatusを`破棄`に変更する
   1. Statusに破棄したADRへのリンクを記載
3. PRを作成し、`main`にセルフマージ


## ADRの記載内容

ADRの各項目の記載内容について説明します。
下記項目以外の項目を追加することは自由です。
あまり厳密に受け止めなくて良いです。

### Title

要約した短い文。ファイル名のタイトル部分と一致させる。

### Status

以下の3つのいずれか。

* 提案済
  * 議論する段階でADRを作成する場合は提案済にする
* 承認済
  * チーム/関係者で合意がとれた状態
  * 実装の準備ができていたりされている状態
* 破棄
  * 新しい決定によって無効になった状態

### Context

決定時の状況を記載します。  
当時のチームの状態であったり、課題や問題意識といった背景について書きます。  
他に検討された代替案があればここに記載します。代替案の記載はAlternatives セクションに記載することもできます。

### Decision

決定内容とその理由を記載します。


### Consequences

実際にやってみてどうだったかを書きます。  
うまくいったこと、いかなかったこと、トレードオフについて。

### Notes

備考欄。以下は必ず記載します。

* Original author: <github_user_name>
* Approval date: 2022-07-21
  * "yyyy-mm-dd"
* Superseded date:

## 参考

ADRについての参考情報。

* [ソフトウェアアーキテクチャの基礎 19章　アーキテクチャ決定](https://www.oreilly.co.jp/books/9784873119823/)