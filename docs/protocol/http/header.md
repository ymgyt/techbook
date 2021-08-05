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


## `Transfer-Encoding`

### `chunked`

server側がresponse全体のサイズを知る前にresponseを返したい場合に指定する。 
HTTP/2ではサポートされていない。  
`Content-Length` headerは省略される。

```text
HTTP/1.1 200 OK
Content-Type: text/plain
Transfer-Encoding: chunked

7\r\n
Mozilla\r\n
9\r\n
Developer\r\n
7\r\n
Network\r\n
0\r\n
\r\n
```

[参考](http://www.silex.jp/blog/wireless/2016/02/http.html)
