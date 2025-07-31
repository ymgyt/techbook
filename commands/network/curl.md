# curl

`curl -fsSLO <url>`

## Options

* `-f`, `--fail` : Serverがコンテンツを返せない時にerror code 22で失敗する。(失敗用のHTMLをうけとるのではなく)
* `-s`, `--silent`: silent
* `-S`, `--show-error`: だけどエラーメッセージをだす
* `-L`: redirectに従う
* `o[O]`:  取得したresponseをファイルに書き出す。Oはサーバー側のファイル名を使う. -oは指定できる
* `-i`: レスポンスの詳細情報
* `-I`: Headerのみ表示
* `-v`: verbose
* `--request|-X`: methodの指定
* `--dump-header`: レスポンスヘッダーをdumpする。出力先のファイルを引数にとるので、`--dump-header -`とするとstdoutにだせる。
* `--write-output`: curl実行後に、stdoutに出力したい情報を指定
  * response codeだけ表示させるといったことができる


## POST

### file(STDIN)の内容をPOSTする

```shell
# --data-binary "@-" とすると STDINをPOSTする
curl -XPUT https://${ES_ENDPOINT}/_bulk --data-binary "@${file}"
```


### json

```shell
curl -i
-X POST \
-H "Content-Type: application/json" \
-d '{"content": "My first post", "author": "Hoge"}' http://127.0.0.1:8080/post/

# jsonがfileにある場合
curl -d @test.json -H "Content-Type: application/json" http://localhost
```


## Body

- ``-d|--data|--data-ascii`` : text data(dataはescape済と想定)
- ``--data-urlencode`` : curlがurl encodeしてくれる
- ``--data-binary`` : binary data
- ``-T|-d @filepath`` : 送信bodyをfileから読む

defaultのContent-Typeはapplication/x-www-form-urlencodedになる


## Headerを付与

``--header "key:value"`` もしくは ``-H "key:value"``

```shell
curl -H "X-Test: Hello" http://localhost:18888
```

### user agent

``--user-agent|-A``

``-H "User-Agent": Mozilla/5.0"`` と明示的に指定しても同じ

## `-w|--write-out`

* [利用できる変数](https://everything.curl.dev/usingcurl/verbose/writeout.html)
