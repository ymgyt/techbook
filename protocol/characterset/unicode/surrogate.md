# Surrogate

* Unicodeは`U+0000` ~ `U+10FFFF`までの番号空間をもっている
* UTF-16のために予約されたCode Pointの範囲
* `U+D800 ~ U+DFFF`

## UTF16

Surrogateの範囲の値を実際にencode後の値として利用している

* 前半: `D800` ~ `DBFF`
* 後半: `DC00` ~ `DFFF`
* 😀 = `D83D` `DE00`
* CodePointとエンコードを分けて考えるはずが、なぜかここではCodePointの値をエンコードに使っている(のが混乱ポイント)
