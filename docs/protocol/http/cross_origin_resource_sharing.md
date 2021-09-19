# Cross Origin Resource Sharing

HTTP Headerに基づいて、Serverが別domain(cross-origin)からのbrowserアクセスを制御できる仕組み。  

## 概要

* JavaScript(js)がloadされたdomainとは別に、fetch等でhttp accessする際にbrowserによるチェックが行われる。
* このcheckはserverが返す、http headerに基づいており、checkに失敗するとjsのリクエストが失敗する。
* Serverはhttp headerを通じてcross originからのaccessがくることを想定して、適切なMWの設定が必要。
* requestの`Origin` headerとresponse headerの`Access-Control-Allow-Origin`の値が一致していることを要求するのが基本。
* Cookieを送るためにはさらに制限が課されている。
* Server側の実装で`Access-Control-XXX`に`*`を使わないのが安定。(credentialとの絡みで仕様で禁止されている。)


### Preflight

HTTP Requestが特定の条件(POSTとか)を満たす場合、browserは実際のrequestに先立って、OPTIONSのrequestを送る。  
Serverからのapprovalをうけて、実際のrequestをsendする。



### Simple requests

requestが特定の条件を満たすと、preflightはsendされない。  
条件の詳細は[仕様](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#simple_requests)参照。  
概要としては
* GET or HEAD or POST
* browserが勝手にセットする以外で許可されたHeaderだけを使っている。(Content-Typeとか)


#### Scenario

request
```shell
GET /resources/public-data/ HTTP/1.1
Host: bar.other
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:71.0) Gecko/20100101 Firefox/71.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-us,en;q=0.5
Accept-Encoding: gzip,deflate
Connection: keep-alive
Origin: https://foo.example
```
`Origin` headerからjsのserve元が`https://foo.example`とわかる。これはbrowserが勝手にいれるので、偽装できない。

response

```shell
HTTP/1.1 200 OK
Date: Mon, 01 Dec 2008 00:23:53 GMT
Server: Apache/2
Access-Control-Allow-Origin: *
Keep-Alive: timeout=2, max=100
Connection: Keep-Alive
Transfer-Encoding: chunked
Content-Type: application/xml

[...Body Data...]
```

### Request with credentials

* defaultの設定ではcross domainに対してcookieはセットされない。
  * request construct時になんらかのflag設定が必要(`withCredentials = true`的な)
  * responseに`Access-Control-Allow-Credentials: true`がないとbrowserはresponseをjsに返さない。
