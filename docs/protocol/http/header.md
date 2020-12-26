# HEADER

## `Accept`

コンテンツネゴシエーション用。  

取得したいdata formatを伝える。

* `Accept: application/json`
* `Accept: application/pdf`
* `Accept: text/csv`

serverが対応できない場合は、406 Not Acceptableを返す。  
headerがない場合はデフォルトの表現を返して良い。


## `Content-Type`

bodyのdata formatを知らせる。   
serverが処理できないdata format(`application/xml`とか)が送られてきたら415 Unsupported Media Typeを返す。

