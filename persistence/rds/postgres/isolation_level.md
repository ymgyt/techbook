# Isolation Level

* Read Committed
  * Non repetableもPhantomも起きる

* `Repetable Read`
  * transaction開始時のSelectの結果(snapshot)が維持される
  * Non repetableもphantomも起きない
