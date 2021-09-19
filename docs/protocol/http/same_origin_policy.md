# Same Origin Policy

* [doc](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)

２つのURLに以下が一致すれば、same-originと判定される。
* protocol(https/http)
* port(もし指定されていれば)
* host

## 具体例

`http://store.company.com/dir/page.html` は

*`http://store.company.com/dir2/other.html` とsame-origin(pathだけが違う)  
*`https://store.company.com/page.html` はfailure (httpとhttps)  
*`http://news.company.com/dir/page.html` はfailure (hostが違う)
