# `std::error`

## `Error`

### `source()`

`fn source(&self) -> Option<&(dyn Error + 'static)>`

* errorが更に原因のerrorをwrapしている場合にそれを返す。
* `cause()`はdeprecatedなのでこちらを使う(`'static` boundをつけたかった?)


### deprecated

* `description()`のかわりは`Display`の実装で行う。
* `cause()`ではなく、`source()`を使う。


### `Box<dyn Error + ...>` does not impl `Error`

* `From`のblanket implと衝突する等して、いろいろ理由があり実装されていない
* https://github.com/rust-lang/rust/pull/58974
