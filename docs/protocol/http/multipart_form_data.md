# `multipart/form-data`

file upload関連の話。

```text
POST /test.html HTTP/1.1
Host: example.org
Content-Type: multipart/form-data;boundary="boundary"

--boundary
Content-Disposition: form-data; name="file_0_0"

value1
--boundary
Content-Disposition: form-data; name="file_1_0"; filename="example.txt"

value2
--boundary--
Content-Disposition: form-data; name="payload";
Content-Type: "application/json"
{"key": "xxx", ... , }
```

こんなリクエストが実際には送られている。

## `<form>` tag

```html
<form enctype="multipart/form-data">
  
</form>
```

* こうなっていると、browser(ui)は`multipart/form-data`形式でPOSTのbodyを作る。

## Header

`Content-Type: multipart/form-data;boundary="-----boundary"` のようにboundaryを指定する。  
boundaryが必要なのは送信するbodyは任意のbyte列なので、そのbyte列に含まれない文字列を指定する必要があるから。  
なので、request側はfileの内容を読んで一致しないようboundaryを生成している。

## subpart

リクエストのHeaderではなく、Bodyのboundaryで区切られている各partの話である点に注意。

* `Content-Disposition`で各partのmeta情報をおくることができる。  
    * `name`はsubpartの識別子。server側がデータを取り出すときに利用する
    * `filename`はsubpartが表しているfile名。
    
* `Content-Type`: subpartが表しているbyte列のContent-Type
