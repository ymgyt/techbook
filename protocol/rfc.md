# RFC

* [1918 Private Address](../network/ip/rfc_1918_private_ip.md)
* [3339 Date and Time on the Internet](./time/rfc_3339.md)
* [4180 CSV](./text/csv.md)
* [4627 JSON](./json/rfc_4627.md)
* [4648 Base64](./encoding/base64.md)
* [6750 Bearer Token Usage](./oauth/rfc_6750_bearer_token.md)
* [6838 MIME](./http/mime.md)
* [7540 HTTP/2](./http2/http2.md)
* [7636 PKCE](./oauth/rfc_7636_pkce.md)

## SHOULDとかMUST

https://www.ipa.go.jp/security/rfc/RFC2119JA.html

### `SHOULD`

> この語句もしくは「推奨される（ RECOMMENDED ）」という形容表現は、 特定の状況下では、特定の項目を無視する正当な理由が存在するかもしれませんが、 異なる選択をする前に、当該項目の示唆するところを十分に理解し、 慎重に重要性を判断しなければならない、ということを意味します。

### `MUST NOT`

> この語句、もしくは「することはない（ SHALL NOT ）」は、その規定が当該仕様の絶対的な禁止事項であることを意味します。

### `MAY`

> この語句、もしくは「選択できる（ OPTIONAL ）」という形容表現は、ある要素が、まさに選択的であることを意味します。 その要素を求めている特定の市場があるから、あるいは、 他のベンダーはその要素を提供しないだろうが、その製品機能を拡張する と察知して、その要素を含む選択をするベンダーがあるかもしれません。 特定の選択事項（オプション）を含まない実装は、おそらく機能的には劣る ことになるでしょうが、そのオプションを含む他の実装との相互運用に備えなければなりません（ MUST ）。 同様に、特定のオプションを含む実装は、そのオプションを含まない実装 との相互運用に備えなければなりません（ MUST ）。
（当然ながら、そのオプションが提供する機能は除かれます。）
