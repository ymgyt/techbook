# CSV

## 4180 Common Format and MIME Type for Comma-Separated Values Files)

* MIMEは `text/csv`
* 改行コードは `CRLF`(`\r\n`)
    * `\n`で区切ってるのは仕様違反..?
      *`encoding/csv`は吸収してくれている。

* 最後のレコードの改行はあってもなくてもよい。

* headerにも決まりがある
    * ファイルの先頭には、オプションとして、通常行と同一の書式を持つ、ヘッダ行が存在してもよい。このヘッダは、ファイル中の各フィールドの名称を保持し、ファイルの残りの部分にある各レコードが持っているのと、同じ数のフィールドを持つべきである。
        * 具体例とか説明いれるのは違反..?
    *  このMIMEタイプのオプションパラメータ"header"で明示するべきである(SHOULD)

* 各行のフィールド数は同じ(SHOULD)
* スペースは無視しない(SHOULD NOT)
    * `strings.TrimXXX`系をはさまないほうがよい。

* 最後のフィールドはカンマで終わってはならない(MUST NOT)

* 各フィールドはダブルクォーテーションで囲んでも囲まなくてもよい。(MAY/MAY NOT)
    * "aaa", bbb, "ccc" みたいなこと(レコードの中でバラバラ)が許されるのかわからない。
    * CRLF, ダブルクォーテーション、カンマを含むフィールドはダブルクォーテーションで囲むべき(SHOULD)
    * ダブルクォーテーションで囲まれているフィールドにダブルクォーテーションがある場合は、ダブルクォーテーションでエス・ケープする。(MUST)

* 読む側は改行コードが`CRLF`以外の場合も念頭において実装する。

### 書いてないこと

結構触れられていないこともある。

* コメントは認められるならどうするのか。
* ヘッダーに重複は許されるのか。

### ABNF

```
file = [header CRLF] record *(CRLF record) [CRLF]
header = name *(COMMA name)
record = field *(COMMA field)
name = field
field = (escaped / non-escaped)
escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
non-escaped = *TEXTDATA
COMMA = %x2C
CR = %x0D ;as per section 6.1 of RFC 2234 [2]
DQUOTE =  %x22 ;as per section 6.1 of RFC 2234 [2]
LF = %x0A ;as per section 6.1 of RFC 2234 [2]
CRLF = CR LF ;as per section 6.1 of RFC 2234 [2]
TEXTDATA =  %x20-21 / %x23-2B / %x2D-7E
```

### 参考

* [RFC4180 日本語訳](http://www.kasai.fm/wiki/rfc4180jp)
