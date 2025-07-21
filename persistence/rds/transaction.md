# Transaction

* Non repetable readとPhantom readの違い
  * 行の内容変更か、行集合の違いか

## Non repetable read

* T1で同じ行を再度読み取った場合に値がかわる

## Phantom read

* T1で同じクエリを再度実行した場合に、前回なかった行が現れたり、消えたりする
  * 結果の行集合がかわる
