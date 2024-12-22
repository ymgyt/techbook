# regex

仕様(Flavor) ごとの異なるが、共通しそうなところはここに書いておく

* `*?` : previous token に0以上matchするが、`*`と違って、as few times as possible 
  * `.*?`
* named capture
  * `(?<name>.*)`
* `\s` whitespace(改行にも) に match
* `\S` non-whitespace に match

