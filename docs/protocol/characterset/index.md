# Character Set

* [ascii](ascii.md)


文字コードという概念は解像度が低い。コンピュータの文字は符号化文字集合(仕様)と文字符号化方式(実装)に分けられる。

## 文字符号化方式

表現したい文字の集合と識別子(code point)の対応関係。  
Unicodeはこれ。例えばUnicodeでは"あ"は U+3042と表される。

### Unicode
Unicodeの中にも種類がある。一般にUnicodeといえば、UCS-4のこと?

## 文字符号化方式

UTF8はここに含まれる。Unicodeをどういうbyte列にするか。  
"あ"(U+3042)を0xE3 0x81 0x82と表現する。  
UTF8はUnicodeだけを扱うが、複数の文字符号方式お扱う文字符号化方式もある。


## ASCII

7bit。man asciiで確認できる。Unicode code pointとUTF8のbyte列表現が同じ。
