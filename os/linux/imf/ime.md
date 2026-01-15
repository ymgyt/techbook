# IME

* Client-Sever方式
* IME daemonがいる

* App <-> IME daemon のプロトコル
  * Wayland
    * input-method-unstable-v1
    * input-method-unstable-v2
    * text-input-unstable-v3
      * compositorが介在する？


```js
// 入力開始
const inputContext = new InputContext();

// AppはIMEにどこで入力されているか教える
inputContext.setCursorLocation(x, y, width, height);

// 入力はAppからIMEに渡す
// Wayland text-input-unstable-v3はコンポジターが介在するらしい
function onKeyPress(keyCode) {
  const isKeyProcessed = inputContext.processKey(keyCode);
  // ...
}


```

## References

* [LinuxでIMEが動作する方法](https://nerufic.com/ja/posts/how-input-methods-work-in-linux/)
