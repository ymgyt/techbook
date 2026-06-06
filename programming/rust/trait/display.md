#  Display

* `std::fmt::Display`
* `to_string()`を生やしたい場合に実装する

単なる文字列化ではなく、意味をもたせたかったり、引数が欲しい場合

* `Display`を実装した専用のstructを返すようにする
　　* `std::path::Path::display()`は`Display`型を返す
